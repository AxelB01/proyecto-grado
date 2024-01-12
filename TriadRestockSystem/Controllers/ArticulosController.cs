using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TriadRestockSystem.Security;
using TriadRestockSystem.ViewModels;
using TriadRestockSystemData.Data;
using TriadRestockSystemData.Data.Models;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize]
    public class ArticulosController : Controller
    {
        private readonly InventarioDBContext _dbContext;
        private readonly IConfiguration _configuration;

        public ArticulosController(InventarioDBContext dBContext, IConfiguration configuration)
        {
            _dbContext = dBContext;
            _configuration = configuration;

        }

        [HttpGet("getArticulos")]
        public ActionResult GetArticulos()
        {
            var items = _dbContext.ArticulosGetAll()
                 .Select(a => new
                 {
                     Id = a.IdArticulo,
                     a.Codigo,
                     a.Nombre,
                     a.Descripcion,
                     a.IdUnidadMedida,
                     a.UnidadMedida,
                     a.CodigoUnidadMedida,
                     a.IdFamilia,
                     a.Familia,
                     a.IdTipoArticulo,
                     a.Tipo,
                     a.IdMarca,
                     a.Marca,
                     a.PrecioBase,
                     a.IdImpuesto,
                     a.Impuesto,
                     a.ImpuestoDecimal,
                     a.ConsumoGeneral,
                     a.NumeroReorden,
                     ConsumoGeneralTexto = a.ConsumoGeneral ? "Sí" : "No",
                     a.IdCreadoPor,
                     a.CreadoPor,
                     Fecha = a.FechaCreacion.ToString("dd/MM/yyyy")
                 })
                 .ToList();

            var brands = _dbContext.Marcas.Select(m => new
            {
                Key = m.IdMarca,
                Text = m.Nombre,
            }).ToList();

            var taxes = _dbContext.Impuestos.Select(i => new
            {
                Key = i.IdImpuesto,
                Text = i.Nombre,
                Value = i.Impuesto1
            }).ToList();

            return Ok(new { items, brands, taxes });
        }



        [HttpGet("getUnidadMedida")]
        public IActionResult GetUnidadMedida()
        {
            var response = _dbContext.UnidadesMedidas
                .Select(v => new
                {
                    Key = v.IdUnidadMedida,
                    Nombre = v.UnidadMedida
                })
                .ToList();
            return Ok(new { items = response });
        }

        [HttpGet("getFamilia")]
        public IActionResult GetFamilia()
        {
            var response = _dbContext.FamiliasArticulos
                .Select(c => new
                {
                    Key = c.IdFamilia,
                    Nombre = c.Familia
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getTipoArticulo")]
        public IActionResult GetTipoArticulo()
        {
            var response = _dbContext.TiposArticulos
                .Select(b => new
                {
                    Key = b.IdTipoArticulo,
                    Nombre = b.Tipo
                })
                .ToList();
            return Ok(new { items = response });
        }

        [HttpPost("guardarArticulo")]
        public IActionResult GuardarArticulo(vmItem model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _dbContext.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _dbContext.Database.BeginTransaction();
                try
                {

                    Marca? marca = _dbContext.Marcas.FirstOrDefault(m => m.IdMarca == model.IdMarca);

                    if (marca == null)
                    {
                        marca = new()
                        {
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now,
                            Nombre = model.Marca
                        };
                        _dbContext.Marcas.Add(marca);
                    }

                    Articulo? articulo = _dbContext.Articulos
                    .Include(v => v.IdUnidadMedidaNavigation)
                    .Include(v => v.IdFamiliaNavigation)
                    .Include(v => v.IdTipoArticuloNavigation)
                    .Include(v => v.IdMarcaNavigation)
                    .Include(v => v.IdImpuestoNavigation)
                    .FirstOrDefault(v => v.IdArticulo == model.IdArticulo);

                    if (articulo == null)
                    {
                        articulo = new Articulo
                        {
                            CreadoPor = user!.IdUsuario,
                            FechaCreacion = DateTime.Now,

                        };
                        _dbContext.Articulos.Add(articulo);
                    }
                    else
                    {
                        articulo.ModificadoPor = user!.IdUsuario;
                        articulo.FechaModificacion = DateTime.Now;
                    }

                    articulo.Nombre = model.Nombre;
                    articulo.Codigo = model.Codigo;
                    articulo.Descripcion = model.Descripcion;
                    articulo.IdUnidadMedida = model.IdUnidadMedida;
                    articulo.IdFamilia = model.IdFamilia;
                    articulo.IdTipoArticulo = model.IdTipoArticulo;
                    articulo.ConsumoGeneral = model.ConsumoGeneral;
                    articulo.NumeroReorden = model.NumeroReorden;
                    articulo.PrecioPorUnidad = Math.Round(model.PrecioBase, 2);
                    articulo.IdImpuesto = model.Impuesto;

                    articulo.IdMarcaNavigation = marca;

                    _dbContext.SaveChanges();
                    dbTran.Commit();
                    return Ok();
                }
                catch (Exception e)
                {
                    dbTran.Rollback();
                    return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                }
            }

            return Unauthorized();

        }

        [HttpGet("getArticulo")]
        public IActionResult GetArticulo(int id)
        {
            Articulo? articulo = _dbContext.Articulos
                 .FirstOrDefault(x => x.IdArticulo == id);

            if (articulo != null)
            {
                vmItem vm = new()
                {
                    IdArticulo = articulo.IdArticulo,
                    IdUnidadMedida = articulo.IdUnidadMedida,
                    Nombre = articulo.Nombre,
                    IdMarca = articulo.IdMarca ?? 1,
                    Codigo = articulo.Codigo,
                    Descripcion = articulo.Descripcion,
                    IdFamilia = articulo.IdFamilia,
                    IdTipoArticulo = articulo.IdTipoArticulo,
                    ConsumoGeneral = articulo.ConsumoGeneral ?? false,
                    NumeroReorden = articulo.NumeroReorden ?? 0,
                    PrecioBase = articulo.PrecioPorUnidad ?? 0.0m,
                    Impuesto = articulo.IdImpuesto ?? 1,
                };
                return Ok(vm);
            }
            else
            {
                return NotFound();
            }

        }
    }
}
