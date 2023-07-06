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
    [Authorize(Roles = RolesNames.ADMINISTRADOR)]
    public class SolicitudesController : ControllerBase
    {
        private readonly InventarioDBContext _db;
        private readonly IConfiguration _configuration;
        public SolicitudesController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;
        }

        [HttpGet("getSolicitudes")]
        public IActionResult GetSolicitudes()
        {
            var response = _db.SolicitudesGetAll()
                .Select(x => new
                {
                    Id = x.IdSolicitud,
                    x.Numero,
                    x.IdCentroCosto,
                    x.CentroCosto,
                    Fecha = x.Fecha.ToString("dd/MM/yyyy"),
                    IdEstado = (int)x.IdEstado,
                    x.Estado,
                    x.IdCreadoPor,
                    x.CreadoPor
                })
                .ToList();
            return Ok(response);
        }

        [HttpGet("getSolicitud")]
        public IActionResult GetSolicitud(int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                try
                {
                    var solicitud = _db.Solicitudes
                        .Include(x => x.IdEstadoNavigation)
                        .Include(x => x.SolicitudesDetalles)
                        .ThenInclude(x => x.IdArticuloNavigation)
                        .ThenInclude(x => x.IdUnidadMedidaNavigation)
                        .First(x => x.IdSolicitud == id);

                    vmRequest model = new()
                    {
                        IdSolicitud = solicitud.IdSolicitud,
                        IdCentroCosto = solicitud.IdCentroCosto,
                        CentroCosto = _db.CentrosCostos.First(c => c.IdCentroCosto == solicitud.IdCentroCosto).Nombre,
                        Numero = solicitud.Numero,
                        Fecha = solicitud.Fecha.ToString("dd/MM/yyyy"),
                        IdEstado = solicitud.IdEstado,
                        Estado = solicitud.IdEstadoNavigation.Estado,
                        IdCreadoPor = solicitud.CreadoPor,
                        CreadoPor = solicitud.CreadoPorNavigation.Login,
                        Detalles = solicitud.SolicitudesDetalles
                        .Select(x => new RequestItem
                        {
                            IdArticulo = x.IdArticulo,
                            Articulo = $"{x.IdArticuloNavigation.Nombre} ({x.IdArticuloNavigation.IdUnidadMedidaNavigation.UnidadMedida})",
                            Cantidad = Convert.ToInt32(x.Cantidad)
                        })
                        .ToArray()
                    };

                    return Ok(model);

                }
                catch (Exception e)
                {
                    return BadRequest(e.Message);
                }
            }

            return Unauthorized();
        }

        [HttpGet("getArticulosList")]
        public IActionResult GetArticulosList()
        {
            var response = _db.ArticulosGetList()
                .Select(x => new
                {
                    Value = x.IdArticulo,
                    Text = $"{x.Nombre} ({x.UnidadMedida})",
                })
                .ToList();
            return Ok(response);
        }

        [HttpPost("guardarSolicitud")]
        public IActionResult GuardarSolicitud(vmRequest model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {
                    var solicitud = _db.Solicitudes
                    .Include(x => x.SolicitudesDetalles)
                    .FirstOrDefault(x => x.IdSolicitud == model.IdSolicitud);

                    if (solicitud == null)
                    {
                        solicitud = new Solicitud
                        {
                            IdCentroCosto = model.IdCentroCosto,
                            Numero = _db.DocumentoGetNumero(1),
                            Fecha = DateTime.Today,
                            IdEstado = (int)IdEstadoSolicitud.Borrador,
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now
                        };
                        _db.Solicitudes.Add(solicitud);
                    }
                    else
                    {
                        solicitud.ModificadoPor = user.IdUsuario;
                        solicitud.FechaModificacion = DateTime.Now;
                    }

                    _db.SolicitudesDetalles.RemoveRange(solicitud.SolicitudesDetalles);
                    solicitud.SolicitudesDetalles.Clear();

                    foreach (var item in model.Detalles)
                    {
                        var detalle = new SolicitudDetalle
                        {
                            IdArticulo = item.IdArticulo,
                            Cantidad = item.Cantidad
                        };

                        solicitud.SolicitudesDetalles.Add(detalle);
                    }

                    _db.SaveChanges();
                    dbTran.Commit();

                    return Ok(solicitud.IdSolicitud);
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
