using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TriadRestockSystem.Security;
using TriadRestockSystem.ViewModels;
using TriadRestockSystemData.Data;
using TriadRestockSystemData.Data.Models;
using TriadRestockSystemData.Data.ViewModels;

namespace TriadRestockSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [JwtData]
    [Authorize(Roles =
        RolesNames.ADMINISTRADOR + "," +
        RolesNames.ALAMCEN_AUXILIAR + "," +
        RolesNames.ALMACEN_ENCARGADO + "," +
        RolesNames.CENTROCOSTOS_AUXILIAR + "," +
        RolesNames.CENTROCOSTOS_ENCARGADO + "," +
        RolesNames.COMPRAS + "," +
        RolesNames.PRESUPUESTO)]
    public class ConfiguracionesController : Controller
    {
        private readonly InventarioDBContext _db;
        public ConfiguracionesController(InventarioDBContext db)
        {
            _db = db;
        }

        [HttpGet("getCostsCentersData")]
        public IActionResult GetCentrosCostos()
        {
            var response = _db.CentrosCostosGetAll()
                .Select(x => new
                {
                    Id = x.IdCentroCosto,
                    x.Nombre,
                    x.CreadoPor,
                    Fecha = x.FechaCreacion.ToString("dd/MM/yyyy")
                })
                .ToList();
            return Ok(response);
        }

        [HttpGet("getCentroCostos")]
        public IActionResult GetCentroCosto(int id)
        {
            var centroCostos = _db.CentrosCostos
                .FirstOrDefault(c => c.IdCentroCosto == id);

            if (centroCostos != null)
            {
                var response = new vmCostCenter
                {
                    IdCentroCosto = centroCostos.IdCentroCosto,
                    Nombre = centroCostos.Nombre
                };

                return Ok(response);
            }

            return NoContent();
        }

        [HttpPost("guardarCentroCostos")]
        public IActionResult GuardarCentroCostos(vmCostCenter model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var dbTran = _db.Database.BeginTransaction();
                try
                {

                    CentrosCosto? centrosCosto = _db.CentrosCostos
                        .FirstOrDefault(c => c.IdCentroCosto == model.IdCentroCosto);

                    if (centrosCosto == null)
                    {
                        centrosCosto = new CentrosCosto
                        {
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now,
                            CodigoCentroCosto = _db.CentrosCostos.Any() ? _db.CentrosCostos.Max(c => c.IdCentroCosto) + 1 : 1
                        };

                        _db.CentrosCostos.Add(centrosCosto);

                    }
                    else
                    {
                        centrosCosto.ModificadoPor = user.IdUsuario;
                        centrosCosto.FechaModificacion = DateTime.Now;
                    }

                    centrosCosto.Nombre = model.Nombre;

                    _db.SaveChanges();
                    dbTran.Commit();

                    return Ok();
                }
                catch (Exception e)
                {
                    dbTran.Rollback();
                    return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                }
            }

            return Unauthorized();
        }

        //[HttpGet("getBancos")]
        //public IActionResult GetBancos()
        //{
        //    var response = _db.Bancos
        //        .Include(b => b.CreadoPorNavigation)
        //        .Include(b => b.CuentasBancos)
        //        .ThenInclude(b => b.IdTipoCuentaNavigation)
        //        .AsEnumerable()
        //        .Select(b => new
        //        {
        //            Key = b.IdBanco,
        //            Banco = b.Nombre,
        //            CreadoPor = b.CreadoPorNavigation.Login,
        //            Fecha = b.FechaCreacion.ToString("dd/MM/yyyy"),
        //            Cuentas = b.CuentasBancos
        //            .Where(c => c.IdBanco == b.IdBanco)
        //            .Select(c => new
        //            {
        //                Key = c.Cuenta,
        //                c.IdBanco,
        //                c.Descripcion,
        //                c.IdTipoCuenta,
        //                TipoCuenta = c.IdTipoCuentaNavigation.Tipo,
        //            }).ToList(),
        //        })
        //        .ToList();

        //    return Ok(response);
        //}

        //[HttpPost("guardarBanco")]
        //public IActionResult GuardarBanco(vmBank model)
        //{
        //    var login = HttpContext.Items["Username"] as string;
        //    var pass = HttpContext.Items["Password"] as string;

        //    Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

        //    if (user != null)
        //    {
        //        var dbTran = _db.Database.BeginTransaction();
        //        try
        //        {
        //            var banco = _db.Bancos.FirstOrDefault(b => b.IdBanco == model.Id);

        //            if (banco == null)
        //            {
        //                banco = new Banco
        //                {
        //                    CreadoPor = user.IdUsuario,
        //                    FechaCreacion = DateTime.Now,
        //                };

        //                _db.Bancos.Add(banco);

        //            }
        //            else
        //            {
        //                banco.ModificadoPor = user.IdUsuario;
        //                banco.FechaModificacion = DateTime.Now;
        //            }

        //            banco.Nombre = model.Nombre;

        //            _db.SaveChanges();
        //            dbTran.Commit();

        //            return Ok();
        //        }
        //        catch (Exception e)
        //        {
        //            dbTran.Rollback();
        //            return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
        //        }
        //    }

        //    return Unauthorized();
        //}

        //[HttpPost("guardarCuentaBanco")]
        //public IActionResult GuardarCuentaBanco(vmBankAccount model)
        //{
        //    var login = HttpContext.Items["Username"] as string;
        //    var pass = HttpContext.Items["Password"] as string;

        //    Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

        //    if (user != null)
        //    {
        //        var dbTran = _db.Database.BeginTransaction();
        //        try
        //        {
        //            var cuentaBanco = _db.CuentasBancos.FirstOrDefault(c => c.Cuenta.Equals(model.Cuenta));

        //            if (cuentaBanco == null)
        //            {
        //                cuentaBanco = new CuentasBanco
        //                {
        //                    IdBanco = model.IdBanco,
        //                    IdTipoCuenta = model.IdTipoCuenta,
        //                    Cuenta = model.Cuenta,
        //                    CreadoPor = user.IdUsuario,
        //                    FechaCreacion = DateTime.Now,
        //                };

        //                _db.CuentasBancos.Add(cuentaBanco);

        //            }
        //            else
        //            {
        //                cuentaBanco.ModificadoPor = user.IdUsuario;
        //                cuentaBanco.FechaModificacion = DateTime.Now;
        //            }

        //            cuentaBanco.Descripcion = model.Descripcion;

        //            _db.SaveChanges();
        //            dbTran.Commit();

        //            return Ok();
        //        }
        //        catch (Exception e)
        //        {
        //            dbTran.Rollback();
        //            return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
        //        }
        //    }

        //    return Unauthorized();
        //}


        [HttpGet("getTipoArticulo")]
        public IActionResult GetTipoArticulos(int id)
        {
            var tipoArticulo = _db.TiposArticulos
                .FirstOrDefault(u => u.IdTipoArticulo == id);

            if (tipoArticulo != null)
            {
                vmItemType vm = new()
                {
                    Id = tipoArticulo.IdTipoArticulo,
                    Nombre = tipoArticulo.Tipo
                };
                return Ok(vm);
            }

            return NotFound();
        }

        [HttpGet("getTipoArticulos")]
        public IActionResult GetTipoArticulos()
        {
            var result = _db.TiposArticulos
                .Select(x => new
                {
                    Key = x.IdTipoArticulo,
                    Id = x.IdTipoArticulo,
                    Nombre = x.Tipo,
                })
                .ToList();
            return Ok(result);
        }

        [HttpPost("guardarTipoArticulos")]
        public IActionResult GuardarTipoArticulos(vmTipoArticulo model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var dbTran = _db.Database.BeginTransaction();
                try
                {
                    TiposArticulo? tipoArticulo = _db.TiposArticulos.FirstOrDefault(c => c.IdTipoArticulo.Equals(model.Id));

                    if (tipoArticulo == null)
                    {
                        tipoArticulo = new TiposArticulo
                        {
                            IdTipoArticulo = model.Id,
                            Tipo = model.Nombre,

                        };

                        _db.TiposArticulos.Add(tipoArticulo);

                    }

                    _db.SaveChanges();
                    dbTran.Commit();

                    return Ok();
                }
                catch (Exception e)
                {
                    dbTran.Rollback();
                    return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                }
            }

            return Unauthorized();
        }

        [HttpPost("guardarUnidadMedida")]
        public IActionResult GuardarUnidadMedida(vmUnidadMedida model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var dbTran = _db.Database.BeginTransaction();
                try
                {
                    UnidadesMedida? unidadesMedida = _db.UnidadesMedidas.FirstOrDefault(c => c.IdUnidadMedida.Equals(model.Id));

                    if (unidadesMedida == null)
                    {
                        unidadesMedida = new UnidadesMedida
                        {
                            IdUnidadMedida = model.Id,
                            UnidadMedida = model.Nombre,
                            Codigo = model.Codigo

                        };

                        _db.UnidadesMedidas.Add(unidadesMedida);

                    }
                    else
                    {

                    }

                    _db.SaveChanges();
                    dbTran.Commit();

                    return Ok();
                }
                catch (Exception e)
                {
                    dbTran.Rollback();
                    return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                }
            }

            return Unauthorized();
        }

        [HttpGet("getUnidadesMedida")]
        public IActionResult GetUnidadesMedida()
        {
            var result = _db.UnidadesMedidas
                .Select(x => new
                {
                    Key = x.IdUnidadMedida,
                    Id = x.IdUnidadMedida,
                    Nombre = x.UnidadMedida,
                    x.Codigo
                })
                .ToList();
            return Ok(result);
        }

        [HttpGet("getUnidadMedida")]
        public IActionResult GetUnidadMedida(int id)
        {
            var unidadMedida = _db.UnidadesMedidas
                .FirstOrDefault(u => u.IdUnidadMedida == id);

            if (unidadMedida != null)
            {
                vmUnidadMedida vm = new()
                {
                    Id = unidadMedida.IdUnidadMedida,
                    Nombre = unidadMedida.UnidadMedida,
                    Codigo = unidadMedida.Codigo
                };
                return Ok(vm);
            }
            else
            {
                return NotFound();
            }
        }
    }
}

