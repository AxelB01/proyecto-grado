using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using TriadRestockSystem.Services;
using TriadRestockSystem.ViewModels;
using TriadRestockSystemData.Data;
using TriadRestockSystemData.Data.Models;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [AllowAnonymous]
    public class AuthController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly InventarioDBContext _db;
        private readonly EncryptionService _encryptionService = new();

        public AuthController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;
        }

        [HttpPost("login")]
        public ActionResult Login([FromBody] vmUserLogin login)
        {
            try
            {
                string key = _configuration.GetValue<string>("AppSettings:AesKey");
                string iv = _configuration.GetValue<string>("AppSettings:AesIV");

                var encryptedPass = _encryptionService.AESEncrypt(key, iv, login.Password);

                var user = _db.Usuarios
                    .Include(u => u.IdRols)
                    .ThenInclude(u => u.RolesModulos)
                    .ThenInclude(r => r.IdModuloNavigation)
                    .FirstOrDefault(u => u.Login.Equals(login.Username.ToLower().Trim()) && u.Password!.Equals(encryptedPass) && u.IdEstado == 1);

                if (user != null)
                {
                    var roles = user.IdRols
                        .Select(r => new
                        {
                            Role = r.IdRol,
                            RoleName = r.Rol,
                            Permissions = r.RolesModulos.Select(p => new
                            {
                                Module = p.IdModuloNavigation.Modulo1,
                                View = p.Vista,
                                Creation = p.Creacion,
                                Management = p.Gestion
                            }).ToList()
                        })
                        .ToList();

                    var token = CreateToken(user);
                    var refreshtoken = CreateRefreshToken();

                    user.RefreshToken = refreshtoken;
                    _db.SaveChanges();

                    var response = new
                    {
                        firstname = user.Nombres,
                        lastname = user.Apellidos,
                        fullname = $"{user.Nombres} {user.Apellidos}".Trim(),
                        username = user.Login.ToLower(),
                        password = user.Password,
                        roles,
                        refreshtoken,
                        token
                    };
                    return Ok(response);
                }

                return Unauthorized("Las credenciales ingresadas son incorrectas");
            }
            catch (Exception e)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
            }
        }

        private string CreateToken(Usuario usuario)
        {

            var claims = new List<Claim>()
            {
                new Claim(ClaimTypes.Name, usuario.Login),
                new Claim(ClaimTypes.Surname, usuario.Password!)
            };

            foreach (var role in usuario.IdRols)
            {
                var claim = new Claim(ClaimTypes.Role, role.Rol);
                claims.Add(claim);
            }

            var key = _configuration.GetValue<string>("AppSettings:TokenKey");
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256Signature);
            var token = new JwtSecurityToken(
                    claims: claims,
                    expires: DateTime.Now.AddMinutes(5),
                    signingCredentials: credentials
                );
            var jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return jwt;
        }

        [HttpPost("getNewAcessToken")]
        public IActionResult GetNewAcessToken([FromBody] vmRefreshToken token)
        {
            var user = RefreshTokenForUser(token.RefreshToken);

            if (user != null)
            {
                var newAcessToken = CreateToken(user);
                return Ok(newAcessToken);
            }

            return Forbid();
        }

        private static string CreateRefreshToken()
        {
            var randomNumber = new byte[32];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(randomNumber);

            return Convert.ToBase64String(randomNumber);
        }

        private Usuario? RefreshTokenForUser(string refreshToken)
        {
            return _db.Usuarios
                .Include(u => u.IdRols)
                .FirstOrDefault(u => u.RefreshToken!.Equals(refreshToken));
        }

    }
}
