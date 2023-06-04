using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TriadRestockSystem.Security;
using TriadRestockSystemData.Data;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize(Roles = RolesNames.ADMINISTRADOR)]
    public class UsuariosController : ControllerBase
    {
        private readonly InventarioDBContext _db;
        private readonly IConfiguration _configuration;
        public UsuariosController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;
        }
    }
}
