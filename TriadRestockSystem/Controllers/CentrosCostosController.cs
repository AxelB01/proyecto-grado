using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TriadRestockSystem.Security;
using TriadRestockSystem.ViewModels;
using TriadRestockSystemData.Data;
using TriadRestockSystemData.Data.Models;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize(Roles = RolesNames.ADMINISTRADOR)]
    public class CentrosCostosController : Controller
    {
        private readonly InventarioDBContext _db;
        public CentrosCostosController(InventarioDBContext db)
        {
            _db = db;
        }

        [HttpGet("getCostsCentersData")]
        public IActionResult GetCentrosCostos()
        {
            var response = _db.CentrosCostosGetAll()
                .Select(x => new
                {
                    Id = x.IdCentroCosto,
                    x.Nombre,
                    x.Cuenta,
                    x.CreadoPor,
                    Fecha = x.FechaCreacion.ToString("dd/MM/yyyy")
                })
                .ToList();
            return Ok(response);
        }

        [HttpGet("getCentroCostos")]
        public IActionResult GetCentroCosto(int id)
        {
            var centroCostos = _db.CentrosCostos
                .FirstOrDefault(c => c.IdCentroCosto == id);

            if (centroCostos != null)
            {
                var response = new vmCostCenter
                {
                    IdCentroCosto = centroCostos.IdCentroCosto,
                    Nombre = centroCostos.Nombre,
                    Cuenta = centroCostos.Cuenta,
                };

                return Ok(response);
            }

            return NoContent();
        }

        [HttpPost("guardarCentroCostos")]
        public IActionResult GuardarCentroCostos(vmCostCenter model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var dbTran = _db.Database.BeginTransaction();
                try
                {
                    CentrosCosto? centrosCosto = _db.CentrosCostos
                        .FirstOrDefault(c => c.IdCentroCosto == model.IdCentroCosto);

                    if (centrosCosto == null)
                    {
                        centrosCosto = new CentrosCosto
                        {
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now,
                            CodigoCentroCosto = _db.CentrosCostos.Max(c => c.CodigoCentroCosto) + 1
                        };

                        _db.CentrosCostos.Add(centrosCosto);

                    }
                    else
                    {
                        centrosCosto.ModificadoPor = user.IdUsuario;
                        centrosCosto.FechaModificacion = DateTime.Now;
                    }

                    centrosCosto.Nombre = model.Nombre;
                    centrosCosto.Cuenta = model.Cuenta;

                    _db.SaveChanges();
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
    }
}
