using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Linq;
using TriadRestockSystem.Security;
using TriadRestockSystemData.Data;
using TriadRestockSystemData.Data.Models;
using TriadRestockSystemData.Data.ViewModels;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize(Roles = RolesNames.ADMINISTRADOR)]
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
            var result = _dbContext.Articulos
                 .Select(x => new
                 {
                     Key = x.IdArticulo,
                     Id = x.IdArticulo,
                     x.IdUnidadMedida,
                     x.Codigo,
                     x.Nombre,
                     x.Descripcion,
                     x.IdFamilia,
                     x.IdTipoArticulo,
                     Fecha = x.FechaCreacion.ToString("dd/MM/yyyy HH:mm:ss"),
                     CreadoPor = x.CreadoPorNavigation.Login
                 })
                 .ToList();
            return Ok(result);
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
            return Ok(new {items = response});
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
            return Ok(new {items = response});
        }

        [HttpPost("guardarArticulo")]
        public IActionResult GuardarArticulo(vmArticulo model) 
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _dbContext.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));


            if (user != null)
            {
                using var dbTran = _dbContext.Database.BeginTransaction();
                try
                {
                    Articulo? articulo = _dbContext.Articulos
                    .Include(v => v.IdUnidadMedidaNavigation)
                    .Include(v => v.IdFamiliaNavigation)
                    .Include(v => v.IdTipoArticuloNavigation)
                    .FirstOrDefault(v => v.IdArticulo == model.IdArticulo);
                    if (articulo == null)
                    {
                        articulo = new Articulo
                        {
                            Codigo = model.Codigo,
                            Nombre = model.Nombre,
                            //IdUnidadMedida = model.IdArticulo,
                            //IdTipoArticulo = model.IdTipoArticulo,
                            //IdFamilia = model.IdFamilia,
                            Descripcion = model.Descripcion,
                            CreadoPor = user!.IdUsuario,
                            FechaCreacion = DateTime.Now,

                        };
                        _dbContext.Articulos.Add(articulo);
                    }
                    else
                    {
                        //articulo.Familia = model.Familia;
                        articulo.ModificadoPor = user!.IdUsuario;
                        articulo.FechaModificacion = DateTime.Now;
                    }

                    //var newUnidadMedida = _dbContext.UnidadesMedidas
                    //        .Where(r => model.IdUnidad.Equals(r.IdUnidadMedida));
                    articulo.IdUnidadMedida = model.IdUnidadMedida;

                    //var newFamilia =_dbContext.FamiliasArticulos
                    //        .Where(r => model.IdFamilia.Equals(r.IdFamilia));
                    articulo.IdFamilia = model.IdFamilia;

                    //var newTipoArticulo = _dbContext.TiposArticulos
                    //        .Where(r => model.IdTipoArticulo.Equals(r.IdTipoArticulo));
                    articulo.IdTipoArticulo = model.IdTipoArticulo;

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
                //.Include(x => x.IdUnidadMedida)
                //.Include(x => x.IdTipoArticulo)
                //.Include(x => x.IdFamilia)
                .FirstOrDefault(x => x.IdArticulo == id);
            if (articulo != null) 
            {
                vmArticulo vm = new()
                {
                    IdArticulo = articulo.IdArticulo,
                    IdUnidadMedida = articulo.IdUnidadMedida, 
                    Nombre = articulo.Nombre,
                    Codigo = articulo.Codigo,
                    Descripcion = articulo.Descripcion,
                    IdFamilia = articulo.IdFamilia,
                    IdTipoArticulo = articulo.IdTipoArticulo,

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
