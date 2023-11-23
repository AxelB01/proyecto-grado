using Microsoft.AspNetCore.Authorization;
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
    [Authorize(Roles = RolesNames.ADMINISTRADOR + "," + RolesNames.ALMACEN_ENCARGADO)]
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
                .Select(a => new
                {
                    Key = a.IdAlmacen,
                    a.Nombre,
                    a.IdEstado,
                    a.IdEstadoNavigation.Estado,
                    a.Descripcion,
                    a.Ubicacion,
                    a.Espacio,
                    IdCreadoPor = a.CreadoPor,
                    CreadoPor = a.CreadoPorNavigation.Login,
                    Fecha = a.FechaCreacion.ToString("dd/MM/yyyy"),
                    Personal = a.UsuariosAlmacenes.Select(u => new
                    {
                        u.IdUsuario,
                        u.IdUsuarioNavigation.Login,
                        Nombre = u.IdUsuarioNavigation.Nombres.Trim() + (u.IdUsuarioNavigation.Apellidos!.Length > 0 ? (" " + u.IdUsuarioNavigation.Apellidos.Trim()) : ""),
                        Puesto = u.IdRolNavigation.Descripcion
                    }).ToList()
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
                .Include(a => a.OrdenesCompras)
                .Include(a => a.UsuariosAlmacenes)
                .ThenInclude(a => a.IdUsuarioNavigation)
                .Include(a => a.UsuariosAlmacenes)
                .ThenInclude(a => a.IdRolNavigation)
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
                    Personal = almacen.UsuariosAlmacenes.Select(u => new Employee
                    {
                        IdUsuario = u.IdUsuario,
                        Username = u.IdUsuarioNavigation.Login,
                        Name = u.IdUsuarioNavigation.Nombres.Trim() + (u.IdUsuarioNavigation.Apellidos!.Length > 0 ? u.IdUsuarioNavigation.Apellidos.Trim() : ""),
                        Role = u.IdRolNavigation.Descripcion ?? ""
                    }).ToList(),
                    IdCreadoPor = almacen.CreadoPor,
                    CreadoPor = almacen.CreadoPorNavigation.Login,
                    CreadorPorNombreCompleto = almacen.CreadoPorNavigation.Nombres.Trim() + (almacen.CreadoPorNavigation.Apellidos!.Length > 0 ? almacen.CreadoPorNavigation.Apellidos.Trim() : ""),
                    Fecha = almacen.FechaCreacion.ToString("dd/MM/yyyy"),
                };

                var solicitudesMateriales = _db.SolicitudesMaterialesByIdAlm(almacen.IdAlmacen).ToList();
                var ordenesCompra = almacen.OrdenesCompras.ToList();
                var secciones = almacen.AlmacenesSecciones
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
                    .Where(r => r.IdAlmacen == id)
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

                var model = new Wharehouse
                {
                    Almacen = almacenInfo,
                    SolicitudesMateriales = solicitudesMateriales,
                    OrdenesCompras = ordenesCompra,
                    Requisiciones = listaRequisiciones,
                    Secciones = secciones,
                    Articulos = articulos
                };

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
                var inventario = _db.InventarioAlmacen(id);
                return Ok(inventario);
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
    }
}
