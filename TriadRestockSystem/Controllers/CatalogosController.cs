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
    [Authorize(Roles = RolesNames.ADMINISTRADOR + "," + RolesNames.ALMACEN_ENCARGADO + "," + RolesNames.ALAMCEN_AUXILIAR)]
    public class CatalogosController : Controller
    {
        private readonly InventarioDBContext _db;
        private readonly IConfiguration _configuration;

        public CatalogosController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;

        }
        [HttpGet("getCatalogos")]
        public IActionResult GetCatalogos()
        {
            var result = _db.Catalogos
                .Select(x => new
                {
                    Key = x.IdCatalogo,
                    Id = x.IdCatalogo,
                    x.Nombre,
                    CreadoPor = x.CreadoPorNavigation.Login,
                    Fecha = x.FechaCreacion.ToString("dd/MM/yyyy"),
                    TotalArticulos = x.IdArticulos.Count,
                    Articulos = _db.Catalogos.First(c => c.IdCatalogo == x.IdCatalogo).IdArticulos.Select(a => a.IdArticulo).ToList()
                })
                .ToList();
            return Ok(result);
        }

        [HttpPost("guardarCatalogo")]
        public IActionResult GuardarCatalogos(vmCatalog model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                Catalogo? catalogo = _db.Catalogos.FirstOrDefault(v => v.IdCatalogo == model.Id);
                if (catalogo == null)
                {
                    catalogo = new Catalogo
                    {
                        Nombre = model.Nombre,
                        CreadoPor = user.IdUsuario,
                        FechaCreacion = DateTime.Now,
                    };
                    _db.Catalogos.Add(catalogo);
                }
                else
                {
                    catalogo.Nombre = model.Nombre;
                    catalogo.ModificadoPor = user.IdUsuario;
                    catalogo.FechaModificacion = DateTime.Now;
                }
                _db.SaveChanges();
                return Ok();
            }

            return Unauthorized();
        }

        [HttpPost("guardarArticulosCatalogo")]
        public IActionResult GuardarArticulosCatalogo(vmCatalog model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                Catalogo? catalogo = _db.Catalogos
                    .Include(c => c.IdArticulos)
                    .FirstOrDefault(c => c.IdCatalogo == model.Id);
                if (catalogo != null)
                {
                    var nuevosArticulos = _db.Articulos
                        .Where(a => model.Detalle.Contains(a.IdArticulo))
                        .ToList();
                    catalogo.IdArticulos = nuevosArticulos;
                    _db.SaveChanges();
                    return Ok();
                }
                return BadRequest();
            }

            return Unauthorized();
        }

        [HttpGet("getCatalogo")]
        public IActionResult GetCatalogo(int id)
        {
            var catalogo = _db.Catalogos
                .FirstOrDefault(u => u.IdCatalogo == id);

            if (catalogo != null)
            {
                vmCatalog vm = new()
                {
                    Id = catalogo.IdCatalogo,
                    Nombre = catalogo.Nombre
                };
                return Ok(vm);
            }

            return NotFound();
        }
    }
}
