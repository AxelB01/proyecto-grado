using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TriadRestockSystem.Security;
using TriadRestockSystemData.Data;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize]
    public class OrdenesCompraController : ControllerBase
    {
        private readonly InventarioDBContext _db;
        private readonly IConfiguration _configuration;

        public OrdenesCompraController(InventarioDBContext db, IConfiguration configuration)
        {
            _db = db;
            _configuration = configuration;

        }

        [HttpGet("getOrdenesCompra")]
        public ActionResult GetOrdenesCompra()
        {
            var result = _db.OrdenesCompras
                .Include(a => a.IdAlmacenNavigation)
                .Include(a => a.IdProveedorNavigation)
                .Include(a => a.IdDocumentoNavigation)
                .Select(x => new
                {
                    Key = x.IdOrdenCompra,
                    Id = x.IdOrdenCompra,
                    Almacen = x.IdAlmacen,
                    Proveedor = x.IdProveedor,
                    Documento = x.IdDocumento,
                    x.SubTotal,
                    x.TotalImpuestos,
                    x.Total,

                })
                .ToList();
            return Ok(result);
        }

        [HttpGet("getRequisiciones")]
        public ActionResult GetRequisicion()
        {
            var result = _db.Requisiciones
                .Include(a => a.IdDocumentoNavigation)
                 .Select(x => new
                 {
                     Key = x.IdRequisicion,
                     Id = x.IdRequisicion,

                 })
                 .ToList();
            return Ok(result);
        }
    }
}
