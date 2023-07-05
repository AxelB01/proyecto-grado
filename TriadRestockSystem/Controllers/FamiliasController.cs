using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Routing;
using Microsoft.EntityFrameworkCore;
using NuGet.Protocol.Plugins;
using System.Linq;
using TriadRestockSystem.Security;
using TriadRestockSystem.ViewModels;
using TriadRestockSystemData.Data;
using TriadRestockSystemData.Data.Models;
using TriadRestockSystemData.Data.ViewModels;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize(Roles = RolesNames.ADMINISTRADOR)]
    public class FamiliasController : ControllerBase
    {
        private readonly InventarioDBContext _dbContext;
        private readonly IConfiguration _configuration;

        public FamiliasController(InventarioDBContext dBContext, IConfiguration configuration)
        {
            _dbContext = dBContext;
            _configuration = configuration;

        }

        [HttpGet("getFamilias")]
        public ActionResult GetFamilias()
        {
            var result = _dbContext.FamiliasArticulos
                .Select(x => new
                {
                    Key = x.IdFamilia, 
                    Id = x.IdFamilia,
                    x.Familia,
                    Fecha = x.FechaCreacion.ToString("dd/MM/yyyy HH:mm:ss"),
                    CreadoPor = x.CreadoPorNavigation.Login
                })
                .ToList();
            return Ok(result);

        }

        [HttpPost("guardarFamilia")]
        public IActionResult GuardarFamilias(vmFamilia model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _dbContext.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if(user != null)
            {
                FamiliaArticulo? familia = _dbContext.FamiliasArticulos.FirstOrDefault(v => v.IdFamilia == model.IdFamilia);
                if (familia == null)
                {
                    familia = new FamiliaArticulo
                    {
                        //IdFamilia = familia.IdFamilia,
                        Familia = model!.Familia,
                        CreadoPor = user.IdUsuario,
                        FechaCreacion = DateTime.Now,
                    };
                    _dbContext.FamiliasArticulos.Add(familia);
                }
                else
                {
                    familia.Familia = model.Familia;
                    familia.ModificadoPor = user.IdUsuario;
                    familia.FechaModificacion = DateTime.Now;
                }
                _dbContext.SaveChanges();
                return Ok();
            }
            return base.Ok();

        }

        [HttpGet("getFamilia")]
        public IActionResult GetFamilia(int id)
        {
            var familia = _dbContext.FamiliasArticulos
                .FirstOrDefault(u => u.IdFamilia == id);
       
            if (familia != null )
            {
                vmFamilia vm = new()
                {
                    IdFamilia = familia.IdFamilia,
                    Familia = familia.Familia
                };
                return Ok(vm);
            }
            else
            {
                return NotFound();
            }
        }
    }
}
