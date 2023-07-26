using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TriadRestockSystem.Security;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize(Roles = RolesNames.ADMINISTRADOR)]
    public class CatalogosController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
