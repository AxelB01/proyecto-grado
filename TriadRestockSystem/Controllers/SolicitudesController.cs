﻿using Microsoft.AspNetCore.Authorization;
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
                    Key = x.IdSolicitudMateriales,
                    x.Numero,
                    x.IdCentroCosto,
                    x.CentroCosto,
                    x.Justificacion,
                    Fecha = x.Fecha.ToString("dd/MM/yyyy"),
                    IdEstado = (int)x.IdEstado,
                    x.Estado,
                    x.IdCreadoPor,
                    x.CreadoPor,
                    NombreCompleto = $"{x.Nombres} {x.Apellidos}".Trim()
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
                        .Include(x => x.IdDocumentoNavigation)
                        .ThenInclude(x => x.CreadoPorNavigation)
                        .Include(x => x.IdCentroCostosNavigation)
                        .Include(x => x.SolicitudesMaterialesDetalles)
                        .ThenInclude(x => x.IdArticuloNavigation)
                        .ThenInclude(x => x.IdUnidadMedidaNavigation)
                        .First(x => x.IdSolicitudMateriales == id);

                    var listaArticulos = _db.ArticulosGetList(solicitud.IdCentroCostos);

                    vmRequest model = new()
                    {
                        IdSolicitud = solicitud.IdSolicitudMateriales,
                        IdCentroCosto = solicitud.IdCentroCostos,
                        CentroCosto = solicitud.IdCentroCostosNavigation.Nombre,
                        Numero = solicitud.IdDocumentoNavigation.Numero,
                        Fecha = solicitud.IdDocumentoNavigation.Fecha.ToString("dd/MM/yyyy"),
                        IdEstado = solicitud.IdDocumentoNavigation.IdEstado,
                        Estado = solicitud.IdDocumentoNavigation.IdEstadoNavigation.Estado,
                        Justificacion = solicitud.IdDocumentoNavigation.Justificacion!,
                        Notas = solicitud.IdDocumentoNavigation.Notas ?? "",
                        IdCreadoPor = solicitud.IdDocumentoNavigation.CreadoPor,
                        CreadoPor = solicitud.IdDocumentoNavigation.CreadoPorNavigation.Login,
                        Detalles = solicitud.SolicitudesMaterialesDetalles
                        .Select(x => new RequestItem
                        {
                            IdArticulo = x.IdArticulo,
                            Articulo = $"{x.IdArticuloNavigation.Nombre} ({x.IdArticuloNavigation.IdUnidadMedidaNavigation.UnidadMedida})",
                            Cantidad = Convert.ToInt32(x.Cantidad),
                            Existencia = listaArticulos.FirstOrDefault(a => a.IdArticulo == x.IdArticulo)?.Existencias ?? 0
                        })
                        .ToArray(),
                        CausaRechazo = solicitud.CausaRechazo
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

        //[HttpGet("getCentroCostoCatalogos")]
        //public IActionResult GetCentroCostoCatalogos(int id)
        //{
        //    var response = _db.CentrosCostos
        //        .Include(a => a.IdCatalogos)
        //        .First(a => a.IdCentroCosto == id)
        //        .IdCatalogos.Select(b => new
        //        {
        //            Key = b.IdCatalogo,
        //            Text = b.Nombre
        //        }).ToList();

        //    return Ok(response);
        //}

        [HttpGet("getCatalogosList")]
        public IActionResult GetCatalogosList(int id)
        {
            var response = _db.CentrosCostos
                .Include(c => c.IdCatalogos)
                .ThenInclude(c => c.IdArticulos)
                .First(c => c.IdCentroCosto == id)
                .IdCatalogos
                .Select(c => new
                {
                    Key = c.IdCatalogo,
                    Value = c.IdCatalogo,
                    Text = c.Nombre,
                    Items = c.IdArticulos.Select(a => a.IdArticulo).ToList()
                }).ToList();

            return Ok(response);
        }

        [HttpGet("getArticulosList")]
        public IActionResult GetArticulosList(int id)
        {
            var response = _db.ArticulosGetList(id)
                .Select(x => new
                {
                    Key = x.IdArticulo,
                    Value = x.IdArticulo,
                    Text = $"{x.Nombre} ({x.UnidadMedida})",
                    Stock = x.Existencias
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

                    solicitud.IdDocumentoNavigation.Justificacion = model.Justificacion;
                    solicitud.IdDocumentoNavigation.Notas = model.Notas ?? "";

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

        [HttpPost("enviarSolicitud")]
        public IActionResult EnviarSolicitud([FromBody] int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var solicitud = _db.SolicitudesMateriales
                    .Include(s => s.IdDocumentoNavigation)
                    .FirstOrDefault(s => s.IdSolicitudMateriales == id);

                if (solicitud != null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {
                        solicitud.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.EnProceso;
                        solicitud.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        solicitud.IdDocumentoNavigation.FechaModificacion = DateTime.Now;

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
            }

            return Unauthorized();
        }

        [HttpPost("archivarSolicitud")]
        public IActionResult ArchivarSolicitud([FromBody] int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var solicitud = _db.SolicitudesMateriales
                    .Include(s => s.IdDocumentoNavigation)
                    .FirstOrDefault(s => s.IdSolicitudMateriales == id);

                if (solicitud != null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {
                        solicitud.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Archivado;
                        solicitud.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        solicitud.IdDocumentoNavigation.FechaModificacion = DateTime.Now;

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
            }

            return Unauthorized();
        }

        [HttpPost("rechazarSolicitud")]
        public IActionResult RechazarSolicitud(vmRejectRequest model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var solicitud = _db.SolicitudesMateriales
                    .Include(s => s.IdDocumentoNavigation)
                    .FirstOrDefault(s => s.IdSolicitudMateriales == model.IdSolicitud);

                if (solicitud != null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {
                        solicitud.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Rechazado;
                        solicitud.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        solicitud.IdDocumentoNavigation.FechaModificacion = DateTime.Now;

                        solicitud.CausaRechazo = model.Causa;

                        _db.SaveChanges();
                        dbTran.Commit();
                    }
                    catch (Exception e)
                    {
                        dbTran.Rollback();
                        return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                    }
                }

                return Ok();
            }

            return Forbid();
        }

        [HttpPost("aprobarSolicitud")]
        public IActionResult AprobarSolicitud([FromBody] int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var solicitud = _db.SolicitudesMateriales
                    .Include(s => s.IdDocumentoNavigation)
                    .FirstOrDefault(s => s.IdSolicitudMateriales == id);

                if (solicitud != null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {
                        var fechaAprobacion = DateTime.Now;

                        solicitud.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Aprobado;
                        solicitud.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        solicitud.IdDocumentoNavigation.FechaModificacion = fechaAprobacion;
                        solicitud.IdDocumentoNavigation.FechaAprobacion = fechaAprobacion;

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
            }

            return Unauthorized();
        }

    }
}
