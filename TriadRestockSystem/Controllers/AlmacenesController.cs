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
                        Nombre = u.IdUsuarioNavigation.Nombres.Trim() + (u.IdUsuarioNavigation.Apellidos!.Length > 0 ? u.IdUsuarioNavigation.Apellidos.Trim() : ""),
                        Puesto = u.IdRolNavigation.Descripcion
                    }).ToList()
                })
                .ToList();

            return Ok(result);
        }

        [HttpGet("getAlmacen")]
        public IActionResult GetAlmacen(int id)
        {
            var almacen = _db.Almacenes
                .Include(a => a.IdEstadoNavigation)
                .Include(a => a.AlmacenesSecciones)
                .ThenInclude(a => a.IdEstadoNavigation)
                .Include(a => a.AlmacenesSecciones)
                .ThenInclude(a => a.IdTipoZonaNavigation)
                .Include(a => a.OrdenesCompras)
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
                    Estado = almacen.IdEstadoNavigation.Estado
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

                foreach (var seccion in secciones)
                {
                    seccion.Estanterias = _db.AlmacenSeccionEstanteriasExistenciasByIdSeccion(seccion.IdAlmacenSeccion).ToList();
                }

                var model = new Wharehouse
                {
                    Almacen = almacenInfo,
                    SolicitudesMateriales = solicitudesMateriales,
                    OrdenesCompras = ordenesCompra,
                    Secciones = secciones
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
                estanteria.IdArticulo = model.IdArticulo;
                estanteria.MinimoRequerido = model.Minimo;
                estanteria.CapacidadMaxima = model.Maximo;

                _db.SaveChanges();
                return Ok();
            }

            return Unauthorized();
        }
    }
}
