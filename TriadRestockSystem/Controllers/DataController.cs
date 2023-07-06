using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TriadRestockSystem.Security;
using TriadRestockSystemData.Data;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize]
    public class DataController : ControllerBase
    {
        private readonly InventarioDBContext _db;

        public DataController(InventarioDBContext db)
        {
            _db = db;
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
    }
}
