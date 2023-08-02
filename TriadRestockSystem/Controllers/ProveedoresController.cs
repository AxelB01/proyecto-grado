using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
    [Authorize(Roles = RolesNames.ADMINISTRADOR)]
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
                .Select(x => new
                {
                    Key = x.IdProveedor,
                    Id = x.IdProveedor,
                    x.Nombre,
                    x.IdEstado,
                    x.Rnc,
                    x.IdPais,
                    x.Direccion,
                    x.CodigoPostal,
                    x.Telefono,
                    x.CorreoElectronico,
                    x.FechaCreacion,
                    Fecha = x.FechaCreacion.ToString("dd/MM/yyyy"),
                    CreadoPor = x.CreadoPorNavigation.Login
                })
                .ToList();
            return Ok(result);
        }

        [HttpGet("getProveedor")]
        public IActionResult GetProveedor(int id)
        {
            var proveedor = _db.Proveedores
                .FirstOrDefault(u => u.IdProveedor == id);

            if (proveedor != null)
            {
                vmProveedores vm = new()
                {
                    Id = proveedor.IdProveedor,
                    Nombre = proveedor.Nombre,
		            RNC = proveedor.Rnc,
		            IdPais = proveedor.IdPais,
		            Direccion = proveedor.Direccion,
		            CodigoPostal = proveedor.CodigoPostal,
		            Telefono = proveedor.Telefono,
		            Correo = proveedor.CorreoElectronico,
		            FechaUltimaCompra = proveedor.FechaUltimaCompra
                };
                return Ok(vm);
            }

            return NotFound();
        }

        [HttpPost("guardarProveedores")]
        public IActionResult GuardarProveedores(vmProveedores model)
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
                        Rnc = model.RNC,
                        IdPais = model.IdPais,
                        Direccion = model.Direccion,
                        CodigoPostal = model.CodigoPostal,
                        Telefono = model.Telefono,
                        CorreoElectronico = model.Correo,
                        FechaUltimaCompra = model.FechaUltimaCompra,
                        CreadoPor = user.IdUsuario,
                        FechaCreacion = DateTime.Now,
                    };
                    _db.Proveedores.Add(proveedor);
                }
                else
                {
                    proveedor.Nombre = model.Nombre;
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
