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
        [HttpGet("getTipoProveedor")]
        public IActionResult GetTipoProveedor()
        {
            var response = _db.TiposProveedores
                .Select(t => new
                {
                    Key = t.IdTipoProveedor,
                    Text = t.TipoProveedor
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
            var response = _db.Articulos
                .Include(a => a.IdUnidadMedidaNavigation)
                .Select(a => new
                {
                    Key = a.IdArticulo,
                    Text = $"{a.Nombre} ({a.IdUnidadMedidaNavigation.UnidadMedida})",
                    ShortText = a.Nombre
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

        [HttpGet("getCatalogos")]
        public IActionResult GetCatalogos()
        {
            var response = _db.Catalogos
                .Select(c => new
                {
                    Key = c.IdCatalogo,
                    Text = c.Nombre,
                    Items = c.IdArticulos.Select(a => a.IdArticulo)
                })
                .ToList();

            return Ok(new { items = response });
        }

        //[HttpGet("getBancos")]
        //public IActionResult GetBancos()
        //{
        //    var response = _db.Bancos
        //        .Select(b => new
        //        {
        //            Key = b.IdBanco,
        //            Text = b.Nombre,
        //        })
        //        .ToList();

        //    return Ok(new { items = response });
        //}

        //[HttpGet("getTiposBancosCuentas")]
        //public IActionResult GetTiposBancosCuentas()
        //{
        //    var response = _db.TiposCuentas
        //        .Select(t => new
        //        {
        //            Key = t.IdTipoCuenta,
        //            Text = t.Tipo,
        //        })
        //        .ToList();

        //    return Ok(new { items = response });
        //}

        //[HttpGet("getCuentasBancos")]
        //public IActionResult GetCuentasBancos()
        //{
        //    var response = _db.CuentasBancos
        //        .Select(c => new
        //        {
        //            Key = c.Cuenta,
        //            BankId = c.IdBanco,
        //            Text = c.Descripcion,
        //            LongText = $"{c.Descripcion} | {c.Cuenta}"
        //        })
        //        .ToList();

        //    return Ok(new { items = response });
        //}

        [HttpGet("getEstadosAlmacenes")]
        public IActionResult GetEstadosAlmacenes()
        {
            var response = _db.EstadosAlmacenes
                .Select(e => new
                {
                    Key = e.IdEstado,
                    Text = e.Estado
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getTiposZonas")]
        public IActionResult GetTiposZonas()
        {
            var response = _db.TiposZonasAlmacenamientos
                .Select(x => new
                {
                    Key = x.IdTipoZonaAlmacenamiento,
                    Text = x.TipoZonaAlmacenamiento
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getArticulosEstados")]
        public IActionResult GetArticulosEstados()
        {
            var response = _db.EstadosArticulos
                .Select(e => new
                {
                    Key = e.IdEstado,
                    Text = e.Estado,
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getAlmacenSecciones")]
        public IActionResult GetAlmacenSecciones()
        {
            var response = _db.AlmacenesSecciones
                .Include(s => s.IdTipoZonaNavigation)
                .Include(s => s.IdEstadoNavigation)
                .Select(s => new
                {
                    s.IdAlmacen,
                    s.IdEstado,
                    s.IdEstadoNavigation.Estado,
                    Key = s.IdAlmacenSeccion,
                    Text = $"{s.Seccion} | {s.IdTipoZonaNavigation.TipoZonaAlmacenamiento}"
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getAlmacenSeccionesEstanterias")]
        public IActionResult GetAlmacenSeccionesEstanterias()
        {
            var response = _db.AlmacenesSeccionesEstanterias
                .Include(es => es.IdEstadoNavigation)
                .Select(es => new
                {
                    es.IdAlmacenSeccion,
                    es.IdEstado,
                    es.IdEstadoNavigation.Estado,
                    Key = es.IdAlmacenSeccionEstanteria,
                    Text = $"{es.Codigo}"

                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getMarcasArticulos")]
        public IActionResult GetMarcasArticulos()
        {
            var response = _db.Marcas
                .Select(m => new
                {
                    Key = m.IdMarca,
                    Text = m.Nombre
                })
                .ToList();

            return Ok(new { items = response });
        }

        [HttpGet("getImpuestosArticulos")]
        public IActionResult GetImpuestosArticulos()
        {
            var response = _db.Impuestos
                .Select(i => new
                {
                    Key = i.IdImpuesto,
                    Text = i.Nombre,
                    Impuesto = i.Impuesto1
                })
                .ToList();

            return Ok(new { items = response });
        }
    }
}
