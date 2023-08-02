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

        [HttpGet("getFamilias")]
        public IActionResult GetFamilias()
        {
            var response = _db.FamiliasArticulos
                .Select(f => new
                {
                    Key = f.IdFamilia,
                    Text = f.Familia
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getUnidadesMedidas")]
        public IActionResult GetUnidadesMedidas()
        {
            var response = _db.UnidadesMedidas
                .Select(u => new
                {
                    Key = u.IdUnidadMedida,
                    Text = u.UnidadMedida
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getTiposArticulos")]
        public IActionResult GetTiposArticulos()
        {
            var response = _db.TiposArticulos
                .Select(t => new
                {
                    Key = t.IdTipoArticulo,
                    Text = t.Tipo
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getEstadosDocumentos")]
        public IActionResult GetEstadosDocumentos()
        {
            var response = _db.EstadosDocumentos
                .Select(e => new
                {
                    Key = e.IdEstado,
                    Text = e.Estado
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getEstadosUsuarios")]
        public IActionResult GetEstadosUsuarios()
        {
            var response = _db.EstadosUsuarios
                .Select(e => new
                {
                    Key = e.IdEstado,
                    Text = e.Estado
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getArticulosList")]
        public IActionResult GetArticulosList()
        {
            var response = _db.ArticulosGetList()
                .Select(x => new
                {
                    Key = x.IdArticulo,
                    Text = $"{x.Nombre} ({x.UnidadMedida})",
                    ShortText = x.Nombre,
                    Stock = x.Existencias
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getPaises")]
        public IActionResult GetPaises()
        {
            var response = _db.Paises
                .Select(e => new
                {
                    Key = e.IdPais,
                    Text = e.Pais
                })
                .ToList();
            return Ok(new { items = response });
        }

        [HttpGet("getEstadosProveedores")]
        public IActionResult GetEstadosProveedores()
        {
            var response = _db.EstadosProveedores
                .Select(e => new
                {
                    Key = e.IdEstado,
                    Text = e.Estado
                })
                .ToList();

            return Ok(new { items = response });
        }

    }
}
