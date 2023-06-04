using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
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
        private readonly Encoding encoding = Encoding.UTF8;

        public AuthController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;
        }

        [HttpPost("login")]
        public ActionResult Login([FromBody] UserLogin login)
        {
            try
            {
                var encryptedPass = AESEncrypt(login.Password);

                var user = _db.Usuarios
                    .Include(u => u.IdRols)
                    .FirstOrDefault(u => u.Login.Equals(login.Username.ToLower().Trim()) && u.Password!.Equals(encryptedPass));

                if (user != null)
                {
                    var roles = user.IdRols.Select(r => r.Rol).ToList();
                    var token = CreateToken(user);

                    var response = new
                    {
                        username = user.Login.ToLower(),
                        password = user.Password,
                        roles,
                        token
                    };
                    return Ok(response);
                }

                return BadRequest("Las credenciales ingresadas son incorrectas");
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
            var securityKey = new SymmetricSecurityKey(encoding.GetBytes(key));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256Signature);
            var token = new JwtSecurityToken(
                    claims: claims,
                    expires: DateTime.Now.AddMinutes(5),
                    signingCredentials: credentials
                );
            var jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return jwt;
        }

        private string AESEncrypt(string inputText)
        {
            string key = _configuration.GetValue<string>("AppSettings:AesKey");
            string iv = _configuration.GetValue<string>("AppSettings:AesIV");

            var inputData = encoding.GetBytes(inputText);

            using var aes = Aes.Create();
            aes.Key = encoding.GetBytes(key);
            aes.IV = encoding.GetBytes(iv);
            aes.Mode = CipherMode.CBC;

            using var outputData = new MemoryStream();
            using var cs = new CryptoStream(outputData, aes.CreateEncryptor(), CryptoStreamMode.Write);
            cs.Write(inputData, 0, inputData.Length);
            cs.FlushFinalBlock();

            var outputText = Convert.ToBase64String(outputData.ToArray());
            return outputText;
        }

        private string AESDecrypt(string inputText)
        {
            string key = _configuration.GetValue<string>("AppSettings:AesKey");
            string iv = _configuration.GetValue<string>("AppSettings:AesIV");

            var inputData = Convert.FromBase64String(inputText);

            using var aes = Aes.Create();
            aes.Key = encoding.GetBytes(key);
            aes.IV = encoding.GetBytes(iv);
            aes.Mode = CipherMode.CBC;

            using var msEncrypt = new MemoryStream(inputData);
            using var cryptoStream = new CryptoStream(msEncrypt, aes.CreateDecryptor(), CryptoStreamMode.Read);
            using var outputData = new StreamReader(cryptoStream, encoding);

            var outputText = outputData.ReadToEnd();
            return outputText;
        }

    }
}
