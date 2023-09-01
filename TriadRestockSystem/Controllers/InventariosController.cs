using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TriadRestockSystem.Security;
using TriadRestockSystem.ViewModels;
using TriadRestockSystemData.Data;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize(Roles = RolesNames.ADMINISTRADOR + "," + RolesNames.ALMACEN_ENCARGADO + "," + RolesNames.ALAMCEN_AUXILIAR)]
    public class InventariosController : Controller
    {
        private readonly InventarioDBContext _db;
        public InventariosController(InventarioDBContext db)
        {
            _db = db;
        }

        [HttpPost("entradaInventario")]
        public IActionResult EntradaInventario(vmInventoryEntry model)
        {
            return Ok(model);
        }
    }
}
