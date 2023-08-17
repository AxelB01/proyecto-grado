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
    public class FamiliasController : ControllerBase
    {
        private readonly InventarioDBContext _db;
        private readonly IConfiguration _configuration;

        public FamiliasController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;

        }

        [HttpGet("getFamilias")]
        public IActionResult GetFamilias()
        {
            var result = _db.FamiliasArticulos
                .Include(x => x.Articulos)
                .Include(x => x.CuentaNavigation)
                .Select(x => new
                {
                    Key = x.IdFamilia,
                    Id = x.IdFamilia,
                    x.Familia,
                    Cuenta = $"{x.CuentaNavigation!.Descripcion} | {x.Cuenta}",
                    x.CuentaNavigation!.IdBanco,
                    TotalArticulos = x.Articulos.Count,
                    Fecha = x.FechaCreacion.ToString("dd/MM/yyyy"),
                    CreadoPor = x.CreadoPorNavigation.Login
                })
                .ToList();
            return Ok(result);
        }

        [HttpPost("guardarFamilia")]
        public IActionResult GuardarFamilia(vmFamily model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                FamiliasArticulo? familia = _db.FamiliasArticulos.FirstOrDefault(v => v.IdFamilia == model.IdFamilia);
                if (familia == null)
                {
                    familia = new FamiliasArticulo
                    {
                        CreadoPor = user.IdUsuario,
                        FechaCreacion = DateTime.Now,
                    };
                    _db.FamiliasArticulos.Add(familia);
                }
                else
                {
                    familia.ModificadoPor = user.IdUsuario;
                    familia.FechaModificacion = DateTime.Now;
                }

                familia.Familia = model.Familia;
                familia.Cuenta = model.Cuenta;

                _db.SaveChanges();
                return Ok();
            }

            return Unauthorized();
        }

        [HttpGet("getFamilia")]
        public IActionResult GetFamilia(int id)
        {
            var familia = _db.FamiliasArticulos
                .Include(f => f.CuentaNavigation)
                .FirstOrDefault(u => u.IdFamilia == id);

            if (familia != null)
            {
                vmFamily vm = new()
                {
                    IdFamilia = familia.IdFamilia,
                    Familia = familia.Familia,
                    IdBanco = familia.CuentaNavigation!.IdBanco,
                    Cuenta = familia.Cuenta!
                };
                return Ok(vm);
            }

            return NotFound();
        }
    }
}
