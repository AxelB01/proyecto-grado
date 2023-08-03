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
            var result = _db.AlmacenesGetAll()
                .Select(a => new
                {
                    Key = a.IdAlmacen,
                    a.Nombre,
                    a.Ubicacion,
                    a.Espacio,
                    a.Descripcion,
                    a.IdCreadoPor,
                    a.CreadoPor,
                    Fecha = a.FechaCreacion.ToString("dd/MM/yyyy")
                }).ToList();
            return Ok(result);
        }
    }
}
