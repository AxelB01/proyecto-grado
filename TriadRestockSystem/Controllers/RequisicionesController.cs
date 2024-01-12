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
    public class RequisicionesController : Controller
    {
        private readonly InventarioDBContext _db;
        public RequisicionesController(InventarioDBContext db)
        {
            _db = db;
        }

        [HttpGet("getRequisiciones")]
        public IActionResult GetRequisiciones()
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var requisiciones = _db.RequisicionesGetAll();

                foreach (var requisicion in requisiciones)
                {
                    requisicion.Detalles = _db.RequisicionDetallesGetById(requisicion.IdRequisicion)
                        .ToList();
                }

                var almacenes = _db.Almacenes
                    .Where(a => a.IdEstado == 1)
                    .Select(a => new
                    {
                        Key = a.IdAlmacen,
                        Text = a.Nombre
                    })
                    .ToList();
                var estados = _db.EstadosDocumentos
                    .Where(e => new int[] { 4, 7 }.Contains(e.IdEstado))
                    .Select(e => new
                    {
                        Key = e.IdEstado,
                        Text = e.Estado
                    })
                    .ToList();

                return Ok(new { requisiciones, almacenes, estados });
            }

            return Forbid();
        }

        [HttpGet("getRequisicionArticulos")]
        public IActionResult GetRequisicionArticulos(int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var response = _db.RequisicionGetItemsById(id);
                return Ok(response);
            }

            return Forbid();
        }

        [HttpPost("saveRequisicionAutomatica")]
        public IActionResult SaveRequisicionAutomatica(vmRequisition model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {
                    if (model.IdRequisicion == 0)
                    {
                        var tipoDocumento = (int)IdTipoDocumento.SolicitudRequisicion;

                        Documento documento = new()
                        {
                            IdTipoDocumento = tipoDocumento,
                            Numero = _db.DocumentoGetNumero(tipoDocumento),
                            Fecha = DateTime.Now,
                            IdEstado = (int)IdEstadoDocumento.Borrador,
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now
                        };

                        Requisicione requisicion = new()
                        {
                            IdAlmacen = model.IdAlmacen
                        };

                        documento.Requisiciones.Add(requisicion);
                        _db.Documentos.Add(documento);

                        foreach (var item in model.Articulos)
                        {
                            RequisicionesDetalle detalle = new()
                            {
                                IdArticulo = item.IdArticulo,
                                Cantidad = item.Cantidad,
                            };

                            requisicion.RequisicionesDetalles.Add(detalle);
                        }

                        _db.SaveChanges();
                        dbTran.Commit();
                    }

                    return Ok(new { status = "Ok" });
                }
                catch (Exception e)
                {
                    dbTran.Rollback();
                    return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                }
            }

            return Forbid();
        }

        [HttpPost("saveRequisicion")]
        public IActionResult SaveRequisicion(vmRequisition model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {
                    var requisicion = _db.Requisiciones
                        .Include(r => r.IdDocumentoNavigation)
                        .Include(r => r.RequisicionesDetalles)
                        .FirstOrDefault(r => r.IdRequisicion == model.IdRequisicion);

                    if (requisicion == null)
                    {
                        var tipoDocumento = (int)IdTipoDocumento.SolicitudRequisicion;

                        Documento documento = new()
                        {
                            IdTipoDocumento = tipoDocumento,
                            Numero = _db.DocumentoGetNumero(tipoDocumento),
                            Fecha = DateTime.Now,
                            IdEstado = (int)IdEstadoDocumento.Borrador,
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now
                        };

                        requisicion = new()
                        {
                            IdAlmacen = model.IdAlmacen
                        };

                        documento.Requisiciones.Add(requisicion);
                        _db.Documentos.Add(documento);
                    }
                    else
                    {
                        requisicion.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        requisicion.IdDocumentoNavigation.FechaModificacion = DateTime.Now;
                    }

                    _db.RequisicionesDetalles.RemoveRange(requisicion.RequisicionesDetalles);
                    requisicion.RequisicionesDetalles.Clear();

                    foreach (var item in model.Articulos)
                    {
                        RequisicionesDetalle detalle = new()
                        {
                            IdArticulo = item.IdArticulo,
                            Cantidad = item.Cantidad,
                        };

                        requisicion.RequisicionesDetalles.Add(detalle);
                    }

                    _db.SaveChanges();
                    dbTran.Commit();

                    return Ok(new { status = "Ok" });
                }
                catch (Exception e)
                {
                    dbTran.Rollback();
                    return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                }
            }

            return Forbid();
        }

        [HttpPost("aprobarRequisicion")]
        public IActionResult AprobarRequisicion([FromBody] int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var requisicion = _db.Requisiciones
                    .Include(r => r.IdDocumentoNavigation)
                    .FirstOrDefault(r => r.IdRequisicion == id);

                if (requisicion != null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {
                        var fecha = DateTime.Now;
                        requisicion.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Aprobado;
                        requisicion.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        requisicion.IdDocumentoNavigation.FechaModificacion = fecha;

                        requisicion.IdDocumentoNavigation.FechaAprobacion = fecha;
                        requisicion.IdDocumentoNavigation.AprobadoPor = user.IdUsuario;

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

        [HttpPost("archivarRequisicion")]
        public IActionResult ArchivarRequisicion([FromBody] int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var requisicion = _db.Requisiciones
                    .Include(r => r.IdDocumentoNavigation)
                    .FirstOrDefault(r => r.IdRequisicion == id);

                if (requisicion != null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {

                        var fecha = DateTime.Now;

                        requisicion.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Archivado;
                        requisicion.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        requisicion.IdDocumentoNavigation.FechaModificacion = fecha;

                        requisicion.IdDocumentoNavigation.FechaArchivado = fecha;
                        requisicion.IdDocumentoNavigation.ArchivadoPor = user.IdUsuario;

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

        [HttpPost("descartarRequisicion")]
        public IActionResult DescartarRequisicion([FromBody] int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var requisicion = _db.Requisiciones
                    .Include(r => r.IdDocumentoNavigation)
                    .FirstOrDefault(r => r.IdRequisicion == id);

                if (requisicion != null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {

                        var fecha = DateTime.Now;

                        requisicion.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Descartado;
                        requisicion.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        requisicion.IdDocumentoNavigation.FechaModificacion = fecha;

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
