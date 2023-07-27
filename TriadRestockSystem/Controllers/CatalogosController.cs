using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
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
                    Fecha = x.FechaCreacion.ToString("dd/MM/yyyy"),
                    CreadoPor = x.CreadoPorNavigation.Login
                })
                .ToList();
            return Ok(result);
        }

        [HttpPost("guardarCatalogo")]
        public IActionResult GuardarCatalogos(vmCatalogo model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                Catalogo? catalogo = _db.Catalogos.FirstOrDefault(v => v.IdCatalogo == model.IdCatalogo);
                if (catalogo == null)
                {
                    catalogo = new Catalogo
                    {
                        Nombre = model!.Nombre,
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

        [HttpGet("getCatalogo")]
        public IActionResult GetCatalogo(int id)
        {
            var catalogo = _db.Catalogos
                .FirstOrDefault(u => u.IdCatalogo == id);

            if (catalogo != null)
            {
                vmCatalogo vm = new()
                {
                    IdCatalogo = catalogo.IdCatalogo,
                    Nombre = catalogo.Nombre
                };
                return Ok(vm);
            }

            return NotFound();
        }
    }
}
