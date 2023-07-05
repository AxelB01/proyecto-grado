using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TriadRestockSystem.Security;
using TriadRestockSystemData.Data;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize(Roles = RolesNames.ADMINISTRADOR)]
    public class SolicitudesController : ControllerBase
    {
        private readonly InventarioDBContext _db;
        private readonly IConfiguration _configuration;
        public SolicitudesController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;
        }

        [HttpGet("getSolicitudes")]
        public IActionResult GetSolicitudes()
        {
            var response = _db.SolicitudesGetAll()
                .ToList();
            return Ok(response);
        }

        [HttpGet("getArticulosList")]
        public IActionResult GetArticulosList()
        {
            var response = _db.ArticulosGetList()
                .Select(x => new
                {
                    Value = x.IdArticulo,
                    Text = x.Nombre
                })
                .ToList();
            return Ok(response);
        }
    }
}
