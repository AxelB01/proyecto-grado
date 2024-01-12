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
    public class OrdenesCompraController : ControllerBase
    {
        private readonly InventarioDBContext _db;
        private readonly IConfiguration _configuration;

        public OrdenesCompraController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;

        }

        [HttpGet("getOrdenesCompra")]
        public ActionResult GetOrdenesCompra()
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var ordenes = _db.OrdenesCompras
                        .Include(o => o.IdDocumentoNavigation)
                        .ThenInclude(o => o.IdEstadoNavigation)
                        .Include(o => o.OrdenesCompraDetalles)
                        .ThenInclude(o => o.IdImpuestoNavigation)
                        .Include(o => o.OrdenesCompraPagoDetalles)
                        .Include(o => o.IdRequisicions)
                        .Where(o => o.IdDocumentoNavigation.IdEstado != (int)IdEstadoDocumento.Descartado)
                        .ToList();

                List<vmPurchaseOrder> listaOrdenes = new();

                foreach (var orden in ordenes)
                {
                    //vmPurchaseOrder model = new();
                    //model.IdOrden = orden.IdOrdenCompra;
                    //model.IdEstado = orden.IdDocumentoNavigation.IdEstado;
                    //model.Estado = orden.IdDocumentoNavigation.IdEstadoNavigation.Estado;
                    //model.Numero = orden.IdDocumentoNavigation.Numero;
                    //model.IdRequisicion = orden.IdRequisicions.First().IdRequisicion;
                    //model.IdAlmacen = orden.IdAlmacen;
                    //model.IdProveedor = orden.IdProveedor;
                    //model.TipoPago = orden.IdTipoPago;
                    //model.FechaEstimada = orden.FechaEntregaEstimada;
                    //model.FechaEntrega = orden.FechaEntrega;
                    //model.Notas = orden.IdDocumentoNavigation.Notas;
                    //model.SubTotal = orden.SubTotal;
                    //model.TotalImpuestos = orden.TotalImpuestos;
                    //model.Total = orden.Total;
                    //model.TotalAPagar = orden.TotalApagar ?? 0.00m;

                    //model.ArticulosDetalles = orden.OrdenesCompraDetalles
                    //.Select(d => new vmPurchaseOrderItemDetail
                    //{
                    //    IdArticulo = d.IdArticulo,
                    //    Cantidad = d.Cantidad,
                    //    IdImpuesto = d.IdImpuesto ?? 1,
                    //    Impuesto = d.IdImpuestoNavigation?.Nombre ?? "Exento",
                    //    ImpuestoDecimal = d.Impuesto ?? 0,
                    //    PrecioBase = d.PrecioUnidad
                    //})
                    //.ToList();

                    //model.PagoDetalles = orden.OrdenesCompraPagoDetalles
                    //.Select(d => new vmPurchaseOrderPaymentDetail
                    //{
                    //    Descripcion = d.Descripcion,
                    //    Tasa = d.Tasa,
                    //    Tipo = d.IdTipoPagoDetalle,
                    //    Valor = d.Valor
                    //})
                    //.ToList();

                    vmPurchaseOrder model = new()
                    {
                        IdOrden = orden.IdOrdenCompra,
                        IdEstado = orden.IdDocumentoNavigation.IdEstado,
                        Estado = orden.IdDocumentoNavigation.IdEstadoNavigation.Estado,
                        Numero = orden.IdDocumentoNavigation.Numero,
                        IdAlmacen = orden.IdAlmacen,
                        IdProveedor = orden.IdProveedor,
                        TipoPago = orden.IdTipoPago,
                        FechaEstimada = orden.FechaEntregaEstimada,
                        FechaEntrega = orden.FechaEntrega,
                        Notas = orden.IdDocumentoNavigation.Notas,
                        SubTotal = orden.SubTotal,
                        TotalImpuestos = orden.TotalImpuestos,
                        Total = orden.Total,
                        TotalAPagar = orden.TotalApagar ?? 0.00m,

                        ArticulosDetalles = orden.OrdenesCompraDetalles
                        .Select(d => new vmPurchaseOrderItemDetail
                        {
                            IdArticulo = d.IdArticulo,
                            Cantidad = d.Cantidad,
                            IdImpuesto = d.IdImpuesto ?? 1,
                            Impuesto = d.IdImpuestoNavigation?.Nombre ?? "Exento",
                            ImpuestoDecimal = d.Impuesto ?? 0,
                            PrecioBase = d.PrecioUnidad
                        }).ToList(),

                        PagoDetalles = orden.OrdenesCompraPagoDetalles
                        .Select(d => new vmPurchaseOrderPaymentDetail
                        {
                            Descripcion = d.Descripcion,
                            Tasa = d.Tasa,
                            Tipo = d.IdTipoPagoDetalle,
                            Valor = d.Valor
                        }).ToList()
                    };

                    if (orden.IdRequisicions.Count > 0)
                    {
                        model.IdRequisicion = orden.IdRequisicions.First().IdRequisicion;
                    }

                    listaOrdenes.Add(model);
                }

                var almacenes = _db.Almacenes
                        .Select(a => new
                        {
                            Key = a.IdAlmacen,
                            Almacen = a.Nombre
                        })
                        .ToList();

                var proveedores = _db.Proveedores
                    .Select(p => new
                    {
                        Key = p.IdProveedor,
                        Proveedor = p.Nombre
                    })
                    .ToList();

                var tiposPagos = _db.OrdenesCompraTiposPagos
                    .Select(t => new
                    {
                        Key = t.IdOrdenCompraTipoPago,
                        t.TipoPago
                    })
                    .ToList();

                var estadosDocumentos = _db.EstadosDocumentos
                    .Select(e => new
                    {
                        Key = e.IdEstado,
                        e.Estado
                    })
                    .ToList();


                return Ok(new { almacenes, proveedores, tiposPagos, estadosDocumentos, ordenesCompra = listaOrdenes });
            }

            return Forbid();
        }

        [HttpGet("getOrdenCompra")]
        public ActionResult GetOrdenCompra(int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var almacenes = _db.Almacenes
                    .Select(a => new
                    {
                        Key = a.IdAlmacen,
                        Almacen = a.Nombre
                    })
                    .ToList();

                var proveedores = _db.Proveedores
                    .Select(p => new
                    {
                        Key = p.IdProveedor,
                        Proveedor = p.Nombre
                    })
                    .ToList();

                var tiposPagos = _db.OrdenesCompraTiposPagos
                    .Select(t => new
                    {
                        Key = t.IdOrdenCompraTipoPago,
                        t.TipoPago
                    })
                    .ToList();

                var tiposDetalles = _db.TiposPagosDetalles
                    .Select(td => new
                    {
                        Key = td.IdTipoPagoDetalle,
                        TipoDetalle = td.PagoDetalle
                    })
                    .ToList();

                var impuestos = _db.Impuestos
                    .Select(i => new
                    {
                        Key = i.IdImpuesto,
                        Value = i.Impuesto1,
                        Label = i.Nombre
                    })
                    .ToList();

                var articulos = _db.ListaArticulosOrdenCompra();

                var orden = _db.OrdenesCompras
                        .Include(o => o.IdDocumentoNavigation)
                        .ThenInclude(o => o.IdEstadoNavigation)
                        .Include(o => o.OrdenesCompraDetalles)
                        .ThenInclude(o => o.IdImpuestoNavigation)
                        .Include(o => o.OrdenesCompraPagoDetalles)
                        .Include(o => o.IdRequisicions)
                        .FirstOrDefault(o => o.IdOrdenCompra == id);


                var model = new vmPurchaseOrder();
                if (orden != null)
                {
                    model.IdOrden = orden.IdOrdenCompra;
                    model.IdEstado = orden.IdDocumentoNavigation.IdEstado;
                    model.Estado = orden.IdDocumentoNavigation.IdEstadoNavigation.Estado;
                    model.Numero = orden.IdDocumentoNavigation.Numero;
                    if (orden.IdRequisicions.Count > 0)
                    {
                        model.IdRequisicion = orden.IdRequisicions.First().IdRequisicion;
                    }
                    model.IdAlmacen = orden.IdAlmacen;
                    model.IdProveedor = orden.IdProveedor;
                    model.TipoPago = orden.IdTipoPago;
                    model.FechaEstimada = orden.FechaEntregaEstimada;
                    model.Notas = orden.IdDocumentoNavigation.Notas;

                    model.ArticulosDetalles = orden.OrdenesCompraDetalles
                        .Select(d => new vmPurchaseOrderItemDetail
                        {
                            IdArticulo = d.IdArticulo,
                            Cantidad = d.Cantidad,
                            IdImpuesto = d.IdImpuesto ?? 1,
                            Impuesto = d.IdImpuestoNavigation?.Nombre ?? "Exento",
                            ImpuestoDecimal = d.Impuesto ?? 0,
                            PrecioBase = d.PrecioUnidad
                        }).ToList();

                    model.PagoDetalles = orden.OrdenesCompraPagoDetalles
                        .Select(d => new vmPurchaseOrderPaymentDetail
                        {
                            Descripcion = d.Descripcion,
                            Tasa = d.Tasa,
                            Tipo = d.IdTipoPagoDetalle,
                            Valor = d.Valor
                        }).ToList();
                }

                return Ok(new { almacenes, proveedores, tiposPagos, tiposDetalles, impuestos, articulos, model });
            }

            return Forbid();
        }

        [HttpPost("guardarOrdenCompra")]
        public ActionResult GuardarOrdenCompra(vmPurchaseOrder model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {
                    var orden = _db.OrdenesCompras
                        .Include(o => o.IdDocumentoNavigation)
                        .ThenInclude(o => o.IdEstadoNavigation)
                        .Include(o => o.OrdenesCompraDetalles)
                        .ThenInclude(o => o.IdImpuestoNavigation)
                        .Include(o => o.OrdenesCompraPagoDetalles)
                        .FirstOrDefault(o => o.IdOrdenCompra == model.IdOrden);

                    int tipoDocumento = (int)IdTipoDocumento.OrdenCompra;

                    string numero;

                    if (orden == null)
                    {

                        numero = _db.DocumentoGetNumero(tipoDocumento);

                        Documento documento = new()
                        {
                            IdTipoDocumento = tipoDocumento,
                            Numero = numero,
                            Fecha = DateTime.Today,
                            IdEstado = (int)IdEstadoDocumento.Borrador,
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now
                        };

                        orden = new OrdenesCompra
                        {
                            IdAlmacen = model.IdAlmacen,
                            IdProveedor = model.IdProveedor,
                            IdTipoPago = model.TipoPago,
                        };

                        documento.OrdenesCompras.Add(orden);
                        _db.Documentos.Add(documento);

                        if (model.IdRequisicion != null)
                        {
                            var requisicion = _db.Requisiciones.First(r => r.IdRequisicion == model.IdRequisicion);
                            orden.IdRequisicions.Add(requisicion);
                        }
                    }
                    else
                    {
                        orden.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        orden.IdDocumentoNavigation.FechaModificacion = DateTime.Now;

                        numero = orden.IdDocumentoNavigation.Numero;
                    }

                    orden.FechaEntregaEstimada = model.FechaEstimada;
                    orden.IdDocumentoNavigation.Notas = model.Notas;

                    _db.OrdenesCompraDetalles.RemoveRange(orden.OrdenesCompraDetalles);
                    orden.OrdenesCompraDetalles.Clear();

                    foreach (var item in model.ArticulosDetalles)
                    {
                        var detalle = new OrdenesCompraDetalle
                        {
                            IdArticulo = item.IdArticulo,
                            Cantidad = item.Cantidad,
                            IdImpuesto = item.IdImpuesto,
                            Impuesto = item.ImpuestoDecimal,
                            PrecioUnidad = item.PrecioBase
                        };

                        item.Impuesto = _db.Impuestos.First(i => i.IdImpuesto == item.IdImpuesto).Nombre;

                        orden.OrdenesCompraDetalles.Add(detalle);
                    }

                    _db.OrdenesCompraPagoDetalles.RemoveRange(orden.OrdenesCompraPagoDetalles);
                    orden.OrdenesCompraPagoDetalles.Clear();

                    foreach (var item in model.PagoDetalles)
                    {
                        var detalle = new OrdenesCompraPagoDetalle
                        {
                            IdTipoPagoDetalle = item.Tipo,
                            Descripcion = item.Descripcion,
                            Tasa = item.Tasa,
                            Valor = item.Valor,
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now
                        };

                        orden.OrdenesCompraPagoDetalles.Add(detalle);
                    }

                    orden.SubTotal = model.SubTotal;
                    orden.TotalImpuestos = model.TotalImpuestos;
                    orden.Total = model.Total;
                    orden.TotalApagar = model.TotalAPagar;

                    _db.SaveChanges();
                    dbTran.Commit();

                    model.IdOrden = orden.IdOrdenCompra;
                    model.Numero = numero;
                    model.IdEstado = (int)IdEstadoDocumento.Borrador;
                    model.Estado = _db.EstadosDocumentos.First(e => e.IdEstado == model.IdEstado).Estado;

                    return Ok(new { status = "Ok", model });
                }
                catch (Exception e)
                {
                    dbTran.Rollback();
                    return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                }
            }

            return Forbid();
        }

        [HttpPost("aprobarOrden")]
        public IActionResult AprobarOrden([FromBody] int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var orden = _db.OrdenesCompras
                        .Include(o => o.IdDocumentoNavigation)
                        .ThenInclude(o => o.IdEstadoNavigation)
                        .Include(o => o.OrdenesCompraDetalles)
                        .ThenInclude(o => o.IdImpuestoNavigation)
                        .Include(o => o.OrdenesCompraPagoDetalles)
                        .Include(o => o.IdRequisicions)
                        .FirstOrDefault(o => o.IdOrdenCompra == id);

                if (orden != null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {
                        orden.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Aprobado;
                        orden.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        orden.IdDocumentoNavigation.FechaModificacion = DateTime.Now;

                        _db.SaveChanges();
                        dbTran.Commit();

                        vmPurchaseOrder model = new()
                        {
                            IdOrden = orden.IdOrdenCompra,
                            IdEstado = (int)IdEstadoDocumento.Aprobado,
                            Estado = _db.EstadosDocumentos.First(e => e.IdEstado == (int)IdEstadoDocumento.Aprobado).Estado,
                            Numero = orden.IdDocumentoNavigation.Numero,
                            IdAlmacen = orden.IdAlmacen,
                            IdProveedor = orden.IdProveedor,
                            TipoPago = orden.IdTipoPago,
                            FechaEstimada = orden.FechaEntregaEstimada,
                            FechaEntrega = orden.FechaEntrega,
                            Notas = orden.IdDocumentoNavigation.Notas,
                            SubTotal = orden.SubTotal,
                            TotalImpuestos = orden.TotalImpuestos,
                            Total = orden.Total,
                            TotalAPagar = orden.TotalApagar ?? 0.00m,

                            ArticulosDetalles = orden.OrdenesCompraDetalles
                            .Select(d => new vmPurchaseOrderItemDetail
                            {
                                IdArticulo = d.IdArticulo,
                                Cantidad = d.Cantidad,
                                IdImpuesto = d.IdImpuesto ?? 1,
                                Impuesto = d.IdImpuestoNavigation?.Nombre ?? "Exento",
                                ImpuestoDecimal = d.Impuesto ?? 0,
                                PrecioBase = d.PrecioUnidad
                            }).ToList(),

                            PagoDetalles = orden.OrdenesCompraPagoDetalles
                            .Select(d => new vmPurchaseOrderPaymentDetail
                            {
                                Descripcion = d.Descripcion,
                                Tasa = d.Tasa,
                                Tipo = d.IdTipoPagoDetalle,
                                Valor = d.Valor
                            }).ToList()
                        };

                        if (orden.IdRequisicions.Count > 0)
                        {
                            model.IdRequisicion = orden.IdRequisicions.First().IdRequisicion;
                        }

                        return Ok(new { data = model });
                    }
                    catch (Exception e)
                    {
                        dbTran.Rollback();
                        return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                    }
                }
            }

            return Forbid();
        }

        [HttpPost("archivarOrden")]
        public IActionResult ArchivarOrden([FromBody] int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var orden = _db.OrdenesCompras
                        .Include(o => o.IdDocumentoNavigation)
                        .ThenInclude(o => o.IdEstadoNavigation)
                        .Include(o => o.OrdenesCompraDetalles)
                        .ThenInclude(o => o.IdImpuestoNavigation)
                        .Include(o => o.OrdenesCompraPagoDetalles)
                        .Include(o => o.IdRequisicions)
                        .FirstOrDefault(o => o.IdOrdenCompra == id);

                if (orden != null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {
                        orden.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Archivado;
                        orden.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        orden.IdDocumentoNavigation.FechaModificacion = DateTime.Now;

                        _db.SaveChanges();
                        dbTran.Commit();

                        vmPurchaseOrder model = new()
                        {
                            IdOrden = orden.IdOrdenCompra,
                            IdEstado = (int)IdEstadoDocumento.Archivado,
                            Estado = _db.EstadosDocumentos.First(e => e.IdEstado == (int)IdEstadoDocumento.Archivado).Estado,
                            Numero = orden.IdDocumentoNavigation.Numero,
                            IdAlmacen = orden.IdAlmacen,
                            IdProveedor = orden.IdProveedor,
                            TipoPago = orden.IdTipoPago,
                            FechaEstimada = orden.FechaEntregaEstimada,
                            FechaEntrega = orden.FechaEntrega,
                            Notas = orden.IdDocumentoNavigation.Notas,
                            SubTotal = orden.SubTotal,
                            TotalImpuestos = orden.TotalImpuestos,
                            Total = orden.Total,
                            TotalAPagar = orden.TotalApagar ?? 0.00m,

                            ArticulosDetalles = orden.OrdenesCompraDetalles
                            .Select(d => new vmPurchaseOrderItemDetail
                            {
                                IdArticulo = d.IdArticulo,
                                Cantidad = d.Cantidad,
                                IdImpuesto = d.IdImpuesto ?? 1,
                                Impuesto = d.IdImpuestoNavigation?.Nombre ?? "Exento",
                                ImpuestoDecimal = d.Impuesto ?? 0,
                                PrecioBase = d.PrecioUnidad
                            }).ToList(),

                            PagoDetalles = orden.OrdenesCompraPagoDetalles
                            .Select(d => new vmPurchaseOrderPaymentDetail
                            {
                                Descripcion = d.Descripcion,
                                Tasa = d.Tasa,
                                Tipo = d.IdTipoPagoDetalle,
                                Valor = d.Valor
                            }).ToList()
                        };

                        if (orden.IdRequisicions.Count > 0)
                        {
                            model.IdRequisicion = orden.IdRequisicions.First().IdRequisicion;
                        }

                        return Ok(new { data = model });
                    }
                    catch (Exception e)
                    {
                        dbTran.Rollback();
                        return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                    }
                }
            }

            return Forbid();
        }

        [HttpPost("descartarOrden")]
        public IActionResult DescartarOrden([FromBody] int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var orden = _db.OrdenesCompras
                        .Include(o => o.IdDocumentoNavigation)
                        .ThenInclude(o => o.IdEstadoNavigation)
                        .Include(o => o.OrdenesCompraDetalles)
                        .ThenInclude(o => o.IdImpuestoNavigation)
                        .Include(o => o.OrdenesCompraPagoDetalles)
                        .Include(o => o.IdRequisicions)
                        .FirstOrDefault(o => o.IdOrdenCompra == id);

                if (orden != null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {
                        orden.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Descartado;
                        orden.IdDocumentoNavigation.ModificadoPor = user.IdUsuario;
                        orden.IdDocumentoNavigation.FechaModificacion = DateTime.Now;

                        _db.SaveChanges();
                        dbTran.Commit();

                        vmPurchaseOrder model = new()
                        {
                            IdOrden = orden.IdOrdenCompra,
                            IdEstado = (int)IdEstadoDocumento.Descartado,
                            Estado = _db.EstadosDocumentos.First(e => e.IdEstado == (int)IdEstadoDocumento.Descartado).Estado,
                            Numero = orden.IdDocumentoNavigation.Numero,
                            IdAlmacen = orden.IdAlmacen,
                            IdProveedor = orden.IdProveedor,
                            TipoPago = orden.IdTipoPago,
                            FechaEstimada = orden.FechaEntregaEstimada,
                            FechaEntrega = orden.FechaEntrega,
                            Notas = orden.IdDocumentoNavigation.Notas,
                            SubTotal = orden.SubTotal,
                            TotalImpuestos = orden.TotalImpuestos,
                            Total = orden.Total,
                            TotalAPagar = orden.TotalApagar ?? 0.00m,

                            ArticulosDetalles = orden.OrdenesCompraDetalles
                            .Select(d => new vmPurchaseOrderItemDetail
                            {
                                IdArticulo = d.IdArticulo,
                                Cantidad = d.Cantidad,
                                IdImpuesto = d.IdImpuesto ?? 1,
                                Impuesto = d.IdImpuestoNavigation?.Nombre ?? "Exento",
                                ImpuestoDecimal = d.Impuesto ?? 0,
                                PrecioBase = d.PrecioUnidad
                            }).ToList(),

                            PagoDetalles = orden.OrdenesCompraPagoDetalles
                            .Select(d => new vmPurchaseOrderPaymentDetail
                            {
                                Descripcion = d.Descripcion,
                                Tasa = d.Tasa,
                                Tipo = d.IdTipoPagoDetalle,
                                Valor = d.Valor
                            }).ToList()
                        };

                        if (orden.IdRequisicions.Count > 0)
                        {
                            model.IdRequisicion = orden.IdRequisicions.First().IdRequisicion;
                        }

                        return Ok(new { data = model });
                    }
                    catch (Exception e)
                    {
                        dbTran.Rollback();
                        return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                    }
                }
            }

            return Forbid();
        }

        //[HttpGet("getRequisiciones")]
        //public ActionResult GetRequisicion()
        //{
        //    var result = _db.Requisiciones
        //        .Include(a => a.IdDocumentoNavigation)
        //         .Select(x => new
        //         {
        //             Key = x.IdRequisicion,
        //             Id = x.IdRequisicion,

        //         })
        //         .ToList();
        //    return Ok(result);
        //}
    }
}
