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
    [Authorize]
    public class RequisicionesController : Controller
    {
        private readonly InventarioDBContext _db;
        public RequisicionesController(InventarioDBContext db)
        {
            _db = db;
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
    }
}
