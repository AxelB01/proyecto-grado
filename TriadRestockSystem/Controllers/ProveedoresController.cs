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
    [Authorize(Roles = RolesNames.ADMINISTRADOR + "," + RolesNames.COMPRAS)]
    public class ProveedoresController : ControllerBase
    {
        private readonly InventarioDBContext _db;
        private readonly IConfiguration _configuration;

        public ProveedoresController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;

        }

        [HttpGet("getProveedores")]
        public IActionResult GetProveedores()
        {
            var result = _db.Proveedores
                .Include(x => x.IdPaisNavigation)
                .Include(x => x.IdTipoProveedorNavigation)
                .Select(x => new
                {
                    Key = x.IdProveedor,
                    Id = x.IdProveedor,
                    x.Nombre,
                    x.IdEstado,
                    x.IdTipoProveedor,
                    x.IdTipoProveedorNavigation.TipoProveedor,
                    x.Rnc,
                    x.IdPais,
                    x.IdPaisNavigation.Pais,
                    x.Direccion,
                    x.CodigoPostal,
                    x.Telefono,
                    x.CorreoElectronico,
                    Fecha = x.FechaCreacion.ToString("dd/MM/yyyy"),
                    CreadoPor = x.CreadoPorNavigation.Login
                })
                .ToList();
            return Ok(result);
        }

        [HttpGet("getProveedor")]
        public IActionResult GetProveedor(int id)
        {
            Proveedore? proveedor = _db.Proveedores
                .FirstOrDefault(u => u.IdProveedor == id);

            if (proveedor != null)
            {
                vmProveedores vm = new()
                {
                    //Key = proveedor.IdProveedor,
                    Id = proveedor.IdProveedor,
                    Nombre = proveedor.Nombre,
                    IdEstado = proveedor.IdEstado,
                    IdTipoProveedor = proveedor.IdTipoProveedor,
                    RNC = proveedor.Rnc,
                    IdPais = proveedor.IdPais,
                    Direccion = proveedor.Direccion,
                    CodigoPostal = proveedor.CodigoPostal,
                    Telefono = proveedor.Telefono,
                    Correo = proveedor.CorreoElectronico,
                };
                return Ok(vm);
            }
            else
            {
                return NotFound();
            }

        }

        [HttpPost("guardarProveedores")]
        public IActionResult GuardarProveedores(vmSuppliers model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                Proveedore? proveedor = _db.Proveedores.FirstOrDefault(v => v.IdProveedor == model.Id);
                if (proveedor == null)
                {
                    proveedor = new Proveedore
                    {
                        Nombre = model.Nombre,
                        IdEstado = model.IdEstado,
                        IdTipoProveedor = model.IdTipoProveedor,
                        Rnc = model.RNC,
                        IdPais = model.IdPais,
                        Direccion = model.Direccion,
                        CodigoPostal = model.CodigoPostal,
                        Telefono = model.Telefono,
                        CorreoElectronico = model.Correo,
                        CreadoPor = user.IdUsuario,
                        FechaCreacion = DateTime.Now,
                    };
                    _db.Proveedores.Add(proveedor);
                }
                else
                {
                    proveedor.Nombre = model.Nombre;
                    proveedor.IdEstado = model.IdEstado;
                    proveedor.IdTipoProveedor = model.IdTipoProveedor;
                    proveedor.Rnc = model.RNC;
                    proveedor.IdPais = model.IdPais;
                    proveedor.Direccion = model.Direccion;
                    proveedor.CodigoPostal = model.CodigoPostal;
                    proveedor.Telefono = model.Telefono;
                    proveedor.CorreoElectronico = model.Correo;
                    proveedor.ModificadoPor = user.IdUsuario;
                    proveedor.FechaModificacion = DateTime.Now;
                }
                _db.SaveChanges();
                return Ok();
            }

            return Unauthorized();
        }

    }
}
