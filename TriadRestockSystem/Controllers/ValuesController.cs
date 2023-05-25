using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        public ValuesController() { }

        [HttpGet("GetName")]
        public ActionResult GetName()
        {
            var response = new
            {
                controllerName = "Values"
            };

            return Ok(response);
        }
    }
}
