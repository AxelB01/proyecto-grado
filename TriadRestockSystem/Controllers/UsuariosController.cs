using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TriadRestockSystem.Security;
using TriadRestockSystem.Services;
using TriadRestockSystem.ViewModels;
using TriadRestockSystemData.Data;
using TriadRestockSystemData.Data.Models;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize(Roles = RolesNames.ADMINISTRADOR)]
    public class UsuariosController : ControllerBase
    {
        private readonly InventarioDBContext _db;
        private readonly IConfiguration _configuration;
        private readonly EncryptionService _encryptionService = new();
        public UsuariosController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;
        }

        [HttpGet("getUsuarios")]
        public IActionResult GetUsuarios()
        {
            var response = _db.UsuariosGetAll()
                .Select(u => new
                {
                    Key = u.IdUsuario,
                    Id = u.IdUsuario,
                    Nombre = u.NombreCompleto,
                    u.Login,
                    u.Estado,
                    u.CreadoPor,
                    Fecha = u.FechaCreacion.ToString("dd/MM/yyyy")
                })
                .ToList();

            return Ok(response);
        }

        [HttpGet("getUsuario")]
        public IActionResult GetUsuario(int id)
        {
            string key = _configuration.GetValue<string>("AppSettings:AesKey");
            string iv = _configuration.GetValue<string>("AppSettings:AesIV");

            Usuario? usuario = _db.Usuarios
                .Include(u => u.IdRols)
                .Include(u => u.IdCentroCostos)
                .FirstOrDefault(u => u.IdUsuario == id);

            if (usuario != null)
            {
                vmUser model = new()
                {
                    Id = usuario.IdUsuario,
                    Name = usuario.Nombres,
                    LastName = usuario.Apellidos,
                    Login = usuario.Login,
                    Password = _encryptionService.AESDecrypt(key, iv, usuario.Password ?? ""),
                    Email = "",
                    State = usuario.IdEstado,
                    Roles = usuario.IdRols.Select(r => r.IdRol).ToArray(),
                    CostCenters = usuario.IdCentroCostos.Select(c => c.IdCentroCosto).ToArray()
                };

                return Ok(model);
            }
            else
            {
                return BadRequest();
            }
        }

        [HttpGet("getRoles")]
        public IActionResult GetRoles()
        {
            var response = _db.Roles
                .Select(r => new
                {
                    Key = r.IdRol,
                    Text = r.Descripcion
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getCentrosCostos")]
        public IActionResult GetCentrosCostos()
        {
            var response = _db.CentrosCostos
                .Select(c => new
                {
                    Key = c.IdCentroCosto,
                    Text = c.Nombre
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpPost("guardarUsuario")]
        public IActionResult GuardarUsuario(vmUser model)
        {

            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {
                    Usuario? usuario = _db.Usuarios
                        .Include(u => u.IdRols)
                        .Include(u => u.IdCentroCostos)
                        .FirstOrDefault(u => u.IdUsuario == model.Id);

                    if (usuario == null)
                    {
                        usuario = new Usuario
                        {
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now
                        };
                        _db.Usuarios.Add(usuario);
                    }
                    else
                    {
                        usuario.ModificadoPor = user.IdUsuario;
                        usuario.FechaModificacion = DateTime.Now;
                    }

                    usuario.Nombres = model.Name;
                    usuario.Apellidos = model.LastName;
                    usuario.Login = model.Login;

                    string key = _configuration.GetValue<string>("AppSettings:AesKey");
                    string iv = _configuration.GetValue<string>("AppSettings:AesIV");
                    usuario.Password = _encryptionService.AESEncrypt(key, iv, model.Password);
                    usuario.IdEstado = model.State;

                    var newRoles = _db.Roles
                        .Where(r => model.Roles.Contains(r.IdRol))
                        .ToList();
                    usuario.IdRols = newRoles;

                    var newCentrosCostos = _db.CentrosCostos
                        .Where(c => model.CostCenters.Contains(c.IdCentroCosto))
                        .ToList();
                    usuario.IdCentroCostos = newCentrosCostos;

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

            return Unauthorized();
        }
    }
}
