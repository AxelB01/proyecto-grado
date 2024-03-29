﻿using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TriadRestockSystem.Security;
using TriadRestockSystem.ViewModels;
using TriadRestockSystemData.Data;
using TriadRestockSystemData.Data.Models;
using TriadRestockSystemData.Data.ViewModels;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize]
    public class AlmacenesController : Controller
    {
        private readonly InventarioDBContext _db;
        public AlmacenesController(InventarioDBContext db)
        {
            _db = db;
        }

        [HttpGet("getAlmacenes")]
        public IActionResult GetAlmacenes()
        {

            var result = _db.Almacenes
                .Include(a => a.IdEstadoNavigation)
                .Include(a => a.CreadoPorNavigation)
                .Include(a => a.IdCentroCostos)
                .Select(a => new
                {
                    Key = a.IdAlmacen,
                    a.Nombre,
                    a.IdEstadoNavigation.Estado,
                    a.Descripcion,
                    a.Ubicacion,
                    a.Espacio,
                    a.IdEstado,
                    EsGeneral = a.EsGeneral ? 1 : 0,
                    IdCreadoPor = a.CreadoPor,
                    CreadoPor = a.CreadoPorNavigation.Login,
                    Fecha = a.FechaCreacion.ToString("dd/MM/yyyy"),
                    Personal = a.UsuariosAlmacenes.Select(u => new
                    {
                        u.IdUsuario,
                        u.IdUsuarioNavigation.Login,
                        Nombre = u.IdUsuarioNavigation.Nombres.Trim() + (u.IdUsuarioNavigation.Apellidos!.Length > 0 ? (" " + u.IdUsuarioNavigation.Apellidos.Trim()) : ""),
                        Puesto = u.IdRolNavigation.Descripcion
                    }).ToList(),
                    CentrosCostos = a.IdCentroCostos.Select(c => c.IdCentroCosto).ToList()
                })
                .ToList();

            return Ok(result);
        }

        [HttpPost("guardarAlmacen")]
        public IActionResult GuardarAlmacen(vmWharehouse model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                Almacene? almacen = _db.Almacenes
                    .Include(v => v.UsuariosAlmacenes)
                    .Include(v => v.IdCentroCostos)
                    .FirstOrDefault(v => v.IdAlmacen == model.IdAlmacen);

                if (almacen == null)
                {
                    almacen = new Almacene
                    {
                        CreadoPor = user.IdUsuario,
                        FechaCreacion = DateTime.Now,
                    };
                    _db.Almacenes.Add(almacen);
                }
                else
                {
                    almacen.ModificadoPor = user.IdUsuario;
                    almacen.FechaModificacion = DateTime.Now;
                }

                almacen.IdEstado = model.IdEstado.GetValueOrDefault();
                almacen.EsGeneral = model.EsGeneral == 1;
                almacen.Nombre = model.Nombre;
                almacen.Descripcion = model.Descripcion.Trim();
                almacen.Ubicacion = model.Ubicacion;
                almacen.Espacio = model.Espacio;

                var roles = _db.Roles
                    .Where(r => new int[] { 2, 3 }.Contains(r.IdRol))
                    .ToList();

                var usuarios = _db.Usuarios
                    .Include(u => u.IdRols)
                    .Where(u => model.IdsPersonal.Contains(u.IdUsuario) && u.IdRols.Any(r => roles.Contains(r)))
                    .ToList();

                List<UsuariosAlmacene> usuariosAlmacen = new();

                foreach (var item in usuarios)
                {
                    UsuariosAlmacene usuarioAlmacen = new()
                    {
                        IdUsuario = item.IdUsuario,
                        IdRol = item.IdRols.First().IdRol
                    };

                    usuariosAlmacen.Add(usuarioAlmacen);
                }

                almacen.UsuariosAlmacenes = usuariosAlmacen;

                var centrosCostos = _db.CentrosCostos
                    .Where(c => model.IdsCentrosCostos.Contains(c.IdCentroCosto))
                    .ToList();

                if (model.EsGeneral == 1)
                {
                    almacen.IdCentroCostos.Clear();
                }
                else
                {
                    almacen.IdCentroCostos = centrosCostos;
                }

                _db.SaveChanges();

                return Ok();
            }

            return Unauthorized();
        }

        [HttpGet("getAlmacen")]
        public IActionResult GetAlmacen(int id)
        {
            var almacen = _db.Almacenes
                .Include(a => a.IdEstadoNavigation)
                .Include(a => a.CreadoPorNavigation)
                .Include(a => a.AlmacenesSecciones)
                .ThenInclude(a => a.IdEstadoNavigation)
                .Include(a => a.AlmacenesSecciones)
                .ThenInclude(a => a.IdTipoZonaNavigation)
                .Include(a => a.UsuariosAlmacenes)
                .ThenInclude(a => a.IdUsuarioNavigation)
                .Include(a => a.UsuariosAlmacenes)
                .ThenInclude(a => a.IdRolNavigation)
                .Include(a => a.IdFamilia)
                .ThenInclude(a => a.Articulos)
                .ThenInclude(a => a.IdUnidadMedidaNavigation)
                .Include(a => a.IdFamilia)
                .ThenInclude(a => a.Articulos)
                .ThenInclude(a => a.IdMarcaNavigation)
                .Include(a => a.IdCentroCostos)
                .Include(a => a.AlmacenesArticulos)
                .FirstOrDefault(a => a.IdAlmacen == id);

            if (almacen != null)
            {
                var almacenInfo = new vmWharehouse
                {
                    IdAlmacen = almacen.IdAlmacen,
                    Nombre = almacen.Nombre,
                    Ubicacion = almacen.Ubicacion,
                    Espacio = almacen.Espacio,
                    Descripcion = almacen.Descripcion,
                    IdEstado = almacen.IdEstado,
                    Estado = almacen.IdEstadoNavigation.Estado,
                    EsGeneral = almacen.EsGeneral ? 1 : 0,
                    Personal = almacen.UsuariosAlmacenes.Select(u => new Employee
                    {
                        IdUsuario = u.IdUsuario,
                        Username = u.IdUsuarioNavigation.Login,
                        Name = u.IdUsuarioNavigation.Nombres.Trim() + (u.IdUsuarioNavigation.Apellidos!.Length > 0 ? u.IdUsuarioNavigation.Apellidos.Trim() : ""),
                        Role = u.IdRolNavigation.Descripcion ?? ""
                    }).ToList(),
                    CentrosCostos = almacen.IdCentroCostos.Select(c => new CostCenter
                    {
                        Id = c.IdCentroCosto,
                        Name = c.Nombre,
                    }).ToList(),
                    IdCreadoPor = almacen.CreadoPor,
                    CreadoPor = almacen.CreadoPorNavigation.Login,
                    CreadorPorNombreCompleto = almacen.CreadoPorNavigation.Nombres.Trim() + (almacen.CreadoPorNavigation.Apellidos!.Length > 0 ? almacen.CreadoPorNavigation.Apellidos.Trim() : ""),
                    Fecha = almacen.FechaCreacion.ToString("dd/MM/yyyy"),
                };

                var secciones = almacen.AlmacenesSecciones
                    .Where(s => s.IdAlmacen == id)
                    .Select(s => new vmAlmacenSeccion
                    {
                        IdAlmacenSeccion = s.IdAlmacenSeccion,
                        Seccion = s.Seccion,
                        IdEstado = s.IdEstado,
                        Estado = s.IdEstadoNavigation.Estado,
                        IdTipoZona = s.IdTipoZona,
                        TipoZonaAlmacenamiento = s.IdTipoZonaNavigation.TipoZonaAlmacenamiento
                    }).ToList();

                var almacenesExistencias = _db.AlmacenSeccionEstanteriasArticulosExistenciasGetByIdAlmacen(id)
                    .AsQueryable();

                foreach (var seccion in secciones)
                {
                    seccion.Estanterias = _db.AlmacenesSeccionesEstanterias
                        .Include(e => e.IdEstadoNavigation)
                        .Where(e => e.IdAlmacenSeccion == seccion.IdAlmacenSeccion)
                        .Select(e => new vmAlmacenSeccionEstanteria
                        {
                            IdAlmacenSeccionEstanteria = e.IdAlmacenSeccionEstanteria,
                            IdAlmacenSeccion = seccion.IdAlmacenSeccion,
                            Codigo = e.Codigo,
                            IdEstado = e.IdEstado,
                            Estado = e.IdEstadoNavigation.Estado
                        })
                        .ToList();

                    foreach (var estanteria in seccion.Estanterias)
                    {
                        estanteria.Existencias = almacenesExistencias
                            .Where(e => e.IdAlmacenSeccionEstanteria == estanteria.IdAlmacenSeccionEstanteria)
                            .ToList();
                    }
                }

                var articulos = _db.AlmacenArticulosGet(id).ToList();

                var requisiciones = _db.Requisiciones
                    .Include(r => r.IdDocumentoNavigation)
                    .ThenInclude(r => r.IdEstadoNavigation)
                    .Include(r => r.RequisicionesDetalles)
                    .ThenInclude(r => r.IdArticuloNavigation)
                    .Where(r => r.IdAlmacen == id && new int[] { 1, 4 }.Contains(r.IdDocumentoNavigation.IdEstado))
                    .OrderBy(r => r.IdDocumentoNavigation.IdEstado)
                    .ThenByDescending(r => r.IdDocumentoNavigation.FechaCreacion)
                    .ToList();

                List<vmRequisition> listaRequisiciones = new();

                foreach (var item in requisiciones)
                {
                    vmRequisition requisicion = new()
                    {
                        IdRequisicion = item.IdRequisicion,
                        IdDocumento = item.IdDocumento,
                        Numero = item.IdDocumentoNavigation.Numero,
                        IdEstado = item.IdDocumentoNavigation.IdEstado,
                        Estado = item.IdDocumentoNavigation.IdEstadoNavigation.Estado,
                        Fecha = item.IdDocumentoNavigation.FechaCreacion,
                        IdAlmacen = id,
                    };

                    foreach (var detalle in item.RequisicionesDetalles)
                    {
                        Articulo articulo = _db.Articulos
                            .Include(a => a.IdFamiliaNavigation)
                            .Include(a => a.IdUnidadMedidaNavigation)
                            .First(a => a.IdArticulo == detalle.IdArticulo);

                        RequisitionItem articuloRequisicion = new()
                        {
                            IdArticulo = detalle.IdArticulo,
                            Key = Guid.NewGuid().ToString("N"),
                            Articulo = articulo.Nombre,
                            Codigo = articulo.Codigo,
                            IdFamilia = articulo.IdFamilia,
                            Familia = articulo.IdFamiliaNavigation.Familia,
                            IdUnidadMedida = articulo.IdUnidadMedida,
                            UnidadMedida = articulo.IdUnidadMedidaNavigation.UnidadMedida,
                            Cantidad = (int)detalle.Cantidad
                        };

                        requisicion.Articulos.Add(articuloRequisicion);
                    }

                    listaRequisiciones.Add(requisicion);
                }

                var familias = almacen.IdFamilia
                    .Select(f => new vmAlmacenFamilia
                    {
                        Key = f.IdFamilia,
                        Name = f.Familia
                    })
                    .ToList();

                List<vmAllowedItem> articulosPermitidos = new();

                var articulosExistencias = _db.InventarioAlmacenArticulosExistencias(id);

                foreach (var familia in almacen.IdFamilia)
                {
                    foreach (var articulo in familia.Articulos)
                    {
                        var nuevoArticulo = articulosPermitidos.FirstOrDefault(a => a.IdArticulo == articulo.IdArticulo);
                        if (nuevoArticulo == null)
                        {
                            nuevoArticulo = new()
                            {
                                IdArticulo = articulo.IdArticulo,
                                Codigo = articulo.Codigo,
                                Nombre = $"{articulo.Nombre} ({articulo.IdUnidadMedidaNavigation.UnidadMedida})",
                            };

                            if (articulosExistencias.Any(x => x.IdArticulo == articulo.IdArticulo))
                            {
                                nuevoArticulo.Existencias = articulosExistencias.First(x => x.IdArticulo == articulo.IdArticulo).Existencias;
                            }

                            articulosPermitidos.Add(nuevoArticulo);
                        }
                    }
                }

                var alamacenArticulos = almacen.AlmacenesArticulos
                    .Select(a => new ItemSorting
                    {
                        Articulo = a.IdArticulo,
                        Minimo = (int)a.CantidadMinima,
                        Maximo = (int)a.CantidadMaxima
                    })
                    .ToList();

                var listaSecciones = _db.AlmacenesSecciones
                .Include(s => s.IdTipoZonaNavigation)
                .Include(s => s.IdEstadoNavigation)
                .Where(s => s.IdAlmacen == id)
                .Select(s => new vmSectionListItem
                {
                    IdAlmacen = s.IdAlmacen,
                    IdEstado = s.IdEstado,
                    Estado = s.IdEstadoNavigation.Estado,
                    Key = s.IdAlmacenSeccion,
                    Text = $"{s.Seccion} | {s.IdTipoZonaNavigation.TipoZonaAlmacenamiento}"
                })
                .ToList();

                var listaSeccionesKeys = listaSecciones.Select(s => s.Key).ToList();

                var listaEstanterias = _db.AlmacenesSeccionesEstanterias
                .Include(es => es.IdEstadoNavigation)
                .Where(es => listaSeccionesKeys.Contains(es.IdAlmacenSeccion))
                .Select(es => new vmSectionShelveListItem
                {
                    IdAlmacenSeccion = es.IdAlmacenSeccion,
                    IdEstado = es.IdEstado,
                    Estado = es.IdEstadoNavigation.Estado,
                    Key = es.IdAlmacenSeccionEstanteria,
                    Text = $"{es.Codigo}"

                })
                .ToList();

                var ordenesCompra = _db.OrdenesCompraByIdAlmacen(id).ToList();

                var solicitudesMateriales = _db.SolicitudesMaterialesByIdAlmacen(id).ToList();

                var model = new Wharehouse
                {
                    Almacen = almacenInfo,
                    SolicitudesMateriales = solicitudesMateriales,
                    OrdenesCompras = ordenesCompra,
                    Requisiciones = listaRequisiciones,
                    Secciones = secciones,
                    Articulos = articulos,
                    Familias = familias,
                    ArticulosPermitidos = articulosPermitidos,
                    ArticulosOrdenamiento = alamacenArticulos,
                    ListaSecciones = listaSecciones,
                    ListaEstanterias = listaEstanterias
                };

                //var serializerOptions = new JsonSerializerOptions
                //{
                //    ReferenceHandler = null,
                //    Converters = { new CustomConverter<Wharehouse>() }
                //};

                //var serializedData = JsonSerializer.Serialize(model, serializerOptions);

                return Ok(model);
            }

            return NotFound();
        }

        [HttpPost("guardarAlmacenSeccion")]
        public IActionResult GuardarAlmacenSeccion(vmSection model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                AlmacenesSeccione? seccion = _db.AlmacenesSecciones.FirstOrDefault(s => s.IdAlmacenSeccion == model.IdSeccion);
                if (seccion == null)
                {
                    seccion = new AlmacenesSeccione
                    {
                        IdAlmacen = model.IdAlmacen,
                        CreadoPor = user.IdUsuario,
                        FechaCreacion = DateTime.Now
                    };
                    _db.AlmacenesSecciones.Add(seccion);
                }
                else
                {
                    seccion.ModificadoPor = user.IdUsuario;
                    seccion.FechaModificacion = DateTime.Now;
                }

                seccion.IdEstado = model.IdEstado;
                seccion.Seccion = model.Seccion;
                seccion.IdTipoZona = model.IdTipoZona;

                _db.SaveChanges();
                return Ok();
            }

            return Unauthorized();
        }


        [HttpPost("guardarAlmacenSeccionEstanteria")]
        public IActionResult GuardarAlmacenSeccionEstanteria(vmSectionStock model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                AlmacenesSeccionesEstanteria? estanteria = _db.AlmacenesSeccionesEstanterias
                    .FirstOrDefault(es => es.IdAlmacenSeccionEstanteria == model.IdEstanteria);

                if (estanteria == null)
                {
                    estanteria = new AlmacenesSeccionesEstanteria
                    {
                        IdAlmacenSeccion = model.IdSeccion,
                        CreadoPor = user.IdUsuario,
                        FechaCreacion = DateTime.Now
                    };
                    _db.AlmacenesSeccionesEstanterias.Add(estanteria);
                }
                else
                {
                    estanteria.ModificadoPor = user.IdUsuario;
                    estanteria.FechaModificacion = DateTime.Now;
                }

                estanteria.IdEstado = model.IdEstado;
                estanteria.Codigo = model.Codigo.Trim();

                _db.SaveChanges();
                return Ok();
            }

            return Unauthorized();
        }

        [HttpGet("inventarioAlmacen")]
        public IActionResult InventarioAlmacen(int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var inventario = _db.InventarioAlmacen(id)
                    .ToList();

                var marcas = _db.Marcas
                    .Select(m => new
                    {
                        Key = m.IdMarca,
                        Text = m.Nombre
                    })
                    .ToList();

                var familias = _db.FamiliasArticulos
                    .Select(m => new
                    {
                        Key = m.IdFamilia,
                        Text = m.Familia
                    })
                    .ToList();

                var posiciones = _db.Almacenes
                    .Include(a => a.AlmacenesSecciones)
                    .ThenInclude(a => a.AlmacenesSeccionesEstanteria)
                    .Select(a => new
                    {
                        Value = a.IdAlmacen,
                        Label = a.Nombre,
                        Children = a.AlmacenesSecciones
                        .Select(s => new
                        {
                            Value = s.IdAlmacenSeccion,
                            Label = s.Seccion,
                            Children = s.AlmacenesSeccionesEstanteria
                            .Select(e => new
                            {
                                Value = e.IdAlmacenSeccionEstanteria,
                                Label = e.Codigo
                            })
                            .ToList()
                        })
                        .ToList()
                    })
                    .ToList();

                return Ok(new { inventario, marcas, familias, posiciones });
            }

            return Unauthorized();
        }

        [HttpGet("almacenPersonal")]
        public IActionResult AlmacenPersonal()
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var response = _db.AlmacenGetPersonal();
                return Ok(new { items = response });
            }

            return Unauthorized();
        }

        [HttpPost("guardarAlmacenesFamilias")]
        public IActionResult GuardarAlmacenFamilias(vmWharehouseFamilies model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {
                    var almacen = _db.Almacenes
                        .Include(a => a.IdFamilia)
                        .First(a => a.IdAlmacen == model.Id);

                    var familias = _db.FamiliasArticulos
                        .Where(f => model.Families.Contains(f.IdFamilia))
                        .ToList();

                    almacen.IdFamilia = familias;

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

            return Forbid();
        }

        [HttpPost("saveAlmacenArticulosOrdenamiento")]
        public IActionResult SaveAlmacenArticulosOrdenamiento(vmWharehouseItemsSorting model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {
                    var almacen = _db.Almacenes
                        .Include(a => a.AlmacenesArticulos)
                        .First(a => a.IdAlmacen == model.Id);

                    _db.AlmacenesArticulos.RemoveRange(almacen.AlmacenesArticulos);
                    almacen.AlmacenesArticulos.Clear();

                    // List<AlmacenesArticulo> articulos = new();

                    var fecha = DateTime.Now;

                    foreach (var item in model.Items)
                    {
                        AlmacenesArticulo articulo = new()
                        {
                            IdArticulo = item.Articulo,
                            CantidadMinima = item.Minimo,
                            CantidadMaxima = item.Maximo,
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = fecha
                        };

                        almacen.AlmacenesArticulos.Add(articulo);
                        // articulos.Add(articulo);
                    }


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

            return Forbid();
        }

        [HttpGet("ordenCompraDetallesRegistro")]
        public IActionResult OrdenCompraDetallesRegistro(int id)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var ordenCompra = _db.OrdenesCompras
                    .Include(o => o.IdDocumentoNavigation)
                    .ThenInclude(o => o.IdEstadoNavigation)
                    .Include(o => o.IdProveedorNavigation)
                    .First(o => o.IdOrdenCompra == id);

                var almacen = _db.Almacenes
                    .Include(a => a.AlmacenesSecciones)
                    .ThenInclude(a => a.AlmacenesSeccionesEstanteria)
                    .First(a => a.IdAlmacen == ordenCompra.IdAlmacen);

                var secciones = almacen.AlmacenesSecciones
                    .Select(s => new
                    {
                        Key = s.IdAlmacenSeccion,
                        Value = s.IdAlmacenSeccion,
                        Label = s.Seccion,
                        Children = s.AlmacenesSeccionesEstanteria.Select(e => new
                        {
                            Key = e.IdAlmacenSeccionEstanteria,
                            Value = e.IdAlmacenSeccionEstanteria,
                            Label = e.Codigo
                        }).ToList()
                    }).ToList();

                var detalles = _db.OrdenCompraAlmacenArticulosGetByIdOrden(ordenCompra.IdOrdenCompra).ToList();

                var response = new
                {
                    almacen.IdAlmacen,
                    Almacen = almacen.Nombre,
                    Posicion = secciones,
                    ordenCompra.IdOrdenCompra,
                    ordenCompra.IdDocumentoNavigation.Numero,
                    ordenCompra.IdDocumentoNavigation.IdEstado,
                    ordenCompra.IdDocumentoNavigation.IdEstadoNavigation.Estado,
                    ordenCompra.IdProveedor,
                    ordenCompra.IdProveedorNavigation.Nombre,
                    ProveedorRNC = ordenCompra.IdProveedorNavigation.Rnc,
                    Factura = "",
                    FechaFactura = DateTime.Now,
                    FechaEntrega = ordenCompra.FechaEntregaEstimada,
                    Detalles = detalles
                };

                return Ok(response);
            }

            return Forbid();
        }

        [HttpPost("saveOrdenCompraDetallesRegistro")]
        public IActionResult SaveOrdenCompraDetallesRegistro(vmWharehousePurchaseOrderRegistration model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {

                using var dbTran = _db.Database.BeginTransaction();
                try
                {
                    var ordenCompra = _db.OrdenesCompras
                        .Include(o => o.IdDocumentoNavigation)
                        .Include(o => o.OrdenesCompraDetalles)
                        .First(o => o.IdOrdenCompra == model.IdOrden);

                    var articulos = _db.Articulos
                        .AsEnumerable()
                        .Where(a => model.Articulos.Any(ma => ma.IdArticulo == a.IdArticulo))
                        .ToList();

                    var date = DateTime.Now;

                    var articulosGuardados = 0;
                    List<vmWharehousePurchaseOrderRegistrationItem> articulosDescartados = new();

                    foreach (var item in model.Articulos)
                    {
                        var articulo = articulos.First(a => a.IdArticulo == item.IdArticulo);
                        if (!_db.Inventarios.Any(i => i.NumeroSerie == item.Codigo))
                        {
                            Inventario inventario = new()
                            {
                                IdArticulo = item.IdArticulo,
                                IdAlmacenSeccionEstanteria = item.Posicion,
                                IdOrdenCompra = ordenCompra.IdOrdenCompra,
                                NumeroSerie = item.Codigo,
                                IdEstado = (int)IdEstadoArticulo.Activo,
                                Notas = item.Notas,
                                CreadoPor = user.IdUsuario,
                                FechaRegistro = date
                            };

                            _db.Inventarios.Add(inventario);
                            articulosGuardados++;
                        }
                        else
                        {
                            articulosDescartados.Add(item);
                        }
                    }

                    _db.SaveChanges();
                    dbTran.Commit();

                    var detalles = _db.OrdenCompraAlmacenArticulosGetByIdOrden(ordenCompra.IdOrdenCompra).ToList();
                    var completa = true;

                    foreach (var item in detalles)
                    {
                        completa = item.Cantidad == 0m;
                    }

                    if (completa)
                    {
                        ordenCompra.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Archivado;
                        _db.SaveChanges();
                    }

                    var status = "Ok";
                    var message = "";

                    if (articulosDescartados.Count > 0)
                    {
                        status = "Error";
                        message = "Aún existen hay por registrar\nEstos códigos de barra ya están registrados: ";
                        var numerosSeriesUsados = "";
                        for (int i = 0; i < articulosDescartados.Count; i++)
                        {
                            var numero = $"{articulosDescartados[i].Codigo}, ";
                            if (i + 1 == articulosDescartados.Count)
                            {
                                numero = $"{articulosDescartados[i].Codigo}";
                            }
                            numerosSeriesUsados += numero;
                        }
                        message += numerosSeriesUsados;
                    }

                    return Ok(new { status, message, count = articulosGuardados, closed = completa });
                }
                catch (Exception e)
                {
                    dbTran.Rollback();
                    return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                }
            }

            return Forbid();
        }

        [HttpGet("cargarSolicitudMaterialesDespacho")]
        public IActionResult CargarSolicitudMaterialesDespacho(int idSolicitud, int idAlmacen)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var almacen = _db.Almacenes
                    .First(a => a.IdAlmacen == idAlmacen);

                var vmAlmacen = new
                {
                    almacen.IdAlmacen,
                    Almacen = almacen.Nombre
                };

                var solicitud = _db.SolicitudesMateriales
                    .Include(s => s.IdCentroCostosNavigation)
                    .Include(s => s.IdDocumentoNavigation)
                    .ThenInclude(s => s.IdEstadoNavigation)
                    .First(s => s.IdSolicitudMateriales == idSolicitud);

                var vmSolicitud = new
                {
                    IdSolicitud = solicitud.IdSolicitudMateriales,
                    solicitud.IdDocumento,
                    solicitud.IdDocumentoNavigation.Numero,
                    IdCentroCosto = solicitud.IdCentroCostos,
                    CentroCosto = solicitud.IdCentroCostosNavigation.Nombre,
                    solicitud.IdDocumentoNavigation.IdEstado,
                    solicitud.IdDocumentoNavigation.IdEstadoNavigation.Estado,
                    solicitud.IdDocumentoNavigation.FechaAprobacion
                };

                var detalles = _db.SolicitudMaterialesDespachoAlmacenDetalles(idSolicitud, idAlmacen)
                    .ToList();

                var articulos = _db.InventarioAlmacenDespachoSolicitud(idAlmacen)
                    .ToList();

                return Ok(new { almacen = vmAlmacen, solicitud = vmSolicitud, detalles, articulos });
            }

            return Forbid();
        }

        [HttpPost("despacharSolicitudMateriales")]
        public IActionResult DespacharSolicitudMateriales(vmWharehouseRequestDispatch model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {

                    int tipoDocumento = (int)IdTipoDocumento.SolicitudDespacho;
                    string numero = _db.DocumentoGetNumero(tipoDocumento);
                    DateTime fecha = DateTime.Now;

                    Documento doc = new()
                    {
                        IdTipoDocumento = tipoDocumento,
                        Numero = numero,
                        Fecha = fecha,
                        IdEstado = (int)IdEstadoDocumento.Aplicado,
                        CreadoPor = user.IdUsuario,
                        FechaCreacion = fecha
                    };

                    SolicitudesDespacho sd = new()
                    {
                        IdSolicitudMateriales = model.IdSolicitud,
                        IdAlmacen = model.IdAlmacen,
                        Total = model.Total
                    };

                    doc.SolicitudesDespachos.Add(sd);

                    List<SolicitudesDespachosDetalle> detalles = new();

                    foreach (var item in model.Detalles)
                    {
                        var articuloInventario = _db.Inventarios
                            .Include(i => i.IdArticuloNavigation)
                            .First(i => i.IdInventario == item);

                        articuloInventario.IdEstado = 2;

                        SolicitudesDespachosDetalle detalle = new()
                        {
                            IdInventario = item,
                            Precio = articuloInventario.IdArticuloNavigation.PrecioPorUnidad ?? 0m
                        };

                        detalles.Add(detalle);
                    }

                    sd.SolicitudesDespachosDetalles = detalles;

                    _db.Documentos.Add(doc);

                    _db.SaveChanges();
                    dbTran.Commit();

                    var solicitudDetalles = _db.SolicitudMaterialesDespachoAlmacenDetalles(model.IdSolicitud, model.IdAlmacen)
                    .ToList();

                    if (solicitudDetalles.Count == 0)
                    {
                        var solicitud = _db.SolicitudesMateriales
                            .Include(s => s.IdDocumentoNavigation)
                            .First(s => s.IdSolicitudMateriales == model.IdSolicitud);

                        var fechaModificacion = DateTime.Now;

                        solicitud.IdDocumentoNavigation.IdEstado = (int)IdEstadoDocumento.Archivado;
                        solicitud.IdDocumentoNavigation.CreadoPor = user.IdUsuario;
                        solicitud.IdDocumentoNavigation.FechaModificacion = fechaModificacion;
                        solicitud.IdDocumentoNavigation.FechaArchivado = fechaModificacion;

                        _db.SaveChanges();
                    }

                    return Ok();
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
