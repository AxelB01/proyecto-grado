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
                    Id = x.IdSolicitudMateriales,
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
                    var solicitud = _db.SolicitudesMateriales
                        .Include(x => x.IdDocumentoNavigation)
                        .ThenInclude(x => x.IdEstadoNavigation)
                        .Include(x => x.IdCentroCostosNavigation)
                        .Include(x => x.SolicitudesMaterialesDetalles)
                        .ThenInclude(x => x.IdArticuloNavigation)
                        .ThenInclude(x => x.IdUnidadMedidaNavigation)
                        .First(x => x.IdSolicitudMateriales == id);

                    vmRequest model = new()
                    {
                        IdSolicitud = solicitud.IdSolicitudMateriales,
                        IdCentroCosto = solicitud.IdCentroCostos,
                        CentroCosto = solicitud.IdCentroCostosNavigation.Nombre,
                        Numero = solicitud.IdDocumentoNavigation.Numero,
                        Fecha = solicitud.IdDocumentoNavigation.Fecha.ToString("dd/MM/yyyy"),
                        IdEstado = solicitud.IdDocumentoNavigation.IdEstado,
                        Estado = solicitud.IdDocumentoNavigation.IdEstadoNavigation.Estado,
                        IdCreadoPor = solicitud.IdDocumentoNavigation.CreadoPor,
                        CreadoPor = solicitud.IdDocumentoNavigation.CreadoPorNavigation.Login,
                        Detalles = solicitud.SolicitudesMaterialesDetalles
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
                    var solicitud = _db.SolicitudesMateriales
                    .Include(x => x.IdDocumentoNavigation)
                    .Include(x => x.SolicitudesMaterialesDetalles)
                    .FirstOrDefault(x => x.IdSolicitudMateriales == model.IdSolicitud);

                    if (solicitud == null)
                    {
                        Documento documento = new()
                        {
                            IdTipoDocumento = (int)IdTipoDocumento.SolicitudMateriales,
                            Numero = _db.DocumentoGetNumero((int)IdTipoDocumento.SolicitudMateriales),
                            Fecha = DateTime.Today,
                            IdEstado = (int)IdEstadoDocumento.Borrador,
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now
                        };

                        solicitud = new SolicitudesMateriale
                        {
                            IdCentroCostos = model.IdCentroCosto
                        };

                        documento.SolicitudesMateriales.Add(solicitud);
                        _db.Documentos.Add(documento);
                    }
                    else
                    {
                        solicitud.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        solicitud.IdDocumentoNavigation.FechaModificacion = DateTime.Now;
                    }

                    _db.SolicitudesMaterialesDetalles.RemoveRange(solicitud.SolicitudesMaterialesDetalles);
                    solicitud.SolicitudesMaterialesDetalles.Clear();

                    foreach (var item in model.Detalles)
                    {
                        var detalle = new SolicitudesMaterialesDetalle
                        {
                            IdArticulo = item.IdArticulo,
                            Cantidad = item.Cantidad
                        };

                        solicitud.SolicitudesMaterialesDetalles.Add(detalle);
                    }

                    _db.SaveChanges();
                    dbTran.Commit();

                    return Ok(solicitud.IdSolicitudMateriales);
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
