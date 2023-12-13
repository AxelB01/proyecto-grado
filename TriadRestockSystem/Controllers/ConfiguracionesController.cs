using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
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
    [Authorize]
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
                    else
                    {
                        tipoArticulo.IdTipoArticulo = model.Id;
                        tipoArticulo.Tipo = model.Nombre;
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
                        unidadesMedida.IdUnidadMedida = model.Id;
                        unidadesMedida.Codigo = model.Codigo;
                        unidadesMedida.UnidadMedida = model.Nombre;
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

        [HttpGet("getConcepts")]
        public IActionResult GetConcepts()
        {
            var conceptos = _db.Conceptos
                .GroupJoin(_db.Conceptos,
                p => p.IdConcepto,
                c => c.IdConceptoPadre,
                (p, c) => new
                {
                    Key = p.IdConcepto,
                    p.IdConcepto,
                    p.IdConceptoPadre,
                    p.CodigoAgrupador,
                    ConceptoPadre = p.Concepto1,
                    Conceptos = c.Where(con => con.IdConceptoPadre == p.IdConcepto)
                    .Select(con => new
                    {
                        con.IdConcepto,
                        con.CodigoAgrupador,
                        Concepto = con.Concepto1
                    })
                })
                .Where(con => !con.IdConceptoPadre.HasValue)
                .ToList();

            return Ok(conceptos);
        }

        [HttpPost("saveConcept")]
        public IActionResult SaveConcept(vmConcept model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {
                    var concepto = _db.Conceptos.FirstOrDefault(c => c.IdConcepto == model.IdConcepto);

                    if (concepto == null)
                    {
                        concepto = new Concepto
                        {
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now
                        };

                        _db.Conceptos.Add(concepto);
                    }

                    if (model.IdConceptoPadre != null)
                    {
                        concepto.IdConceptoPadre = model.IdConceptoPadre;
                        concepto.CodigoAgrupador = _db.ConceptoGetCodigoAgrupador((int)model.IdConceptoPadre);
                    }
                    else
                    {
                        concepto.CodigoAgrupador = model.CodigoAgrupador;
                    }

                    concepto.Concepto1 = model.Concepto;
                    concepto.ModificadoPor = user.IdUsuario;
                    concepto.FechaModificacion = DateTime.Now;

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

            return Forbid();
        }

        [HttpGet("getRolesModules")]
        public IActionResult GetRolesModules()
        {
            var roles = _db.Roles
                .Include(r => r.RolesModulos)
                .ThenInclude(rm => rm.IdModuloNavigation)
                .Select(r => new
                {
                    Key = r.IdRol,
                    Role = r.Rol,
                    Description = r.Descripcion,
                    Permissions = r.RolesModulos.Select(rm => new
                    {
                        Key = $"{r.IdRol}-{rm.IdModulo}",
                        Module = rm.IdModuloNavigation.Modulo1,
                        View = rm.Vista,
                        Creation = rm.Creacion,
                        Management = rm.Gestion
                    }).ToList()
                })
                .ToList();

            var modules = _db.Modulos
                .Select(m => new
                {
                    Key = m.IdModulo,
                    Module = m.Modulo1
                })
                .ToList();

            return Ok(new { roles, modules });
        }

        [HttpPost("saveRole")]
        public IActionResult SaveRole(vmRole model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {

                    var rol = _db.Roles
                        .Include(r => r.RolesModulos)
                        .FirstOrDefault(r => r.IdRol == model.IdRole);

                    if (rol == null)
                    {
                        rol = new Role
                        {
                            IdRol = _db.Roles.Count() + 1,
                            CreadoPor = user.IdUsuario,
                            FechaCreacion = DateTime.Now
                        };

                        _db.Roles.Add(rol);
                    }
                    else
                    {
                        rol.ModificadoPor = user.IdUsuario;
                        rol.FechaModificacion = DateTime.Now;
                    }

                    rol.Rol = model.Role;
                    rol.Descripcion = model.Description;

                    _db.SaveChanges();

                    if (rol.RolesModulos.Count == 0)
                    {
                        _db.RolesModulosSetUp(rol.IdRol);
                    }

                    dbTran.Commit();

                    return Ok();
                }
                catch (Exception e)
                {
                    dbTran.Rollback();
                    return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                }
            }

            return Forbid();
        }

        [HttpPost("saveRolePermissions")]
        public IActionResult SaveRolePermissions(vmRolePermissions model)
        {
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                using var dbTran = _db.Database.BeginTransaction();
                try
                {
                    var role = _db.Roles
                        .Include(r => r.RolesModulos)
                        .First(r => r.IdRol == model.IdRole);

                    var datetime = DateTime.Now;

                    foreach (var item in model.Permissions)
                    {
                        var permission = role.RolesModulos.First(rm => rm.IdModulo == item.Id);
                        permission.Vista = item.View;
                        permission.Creacion = item.Creation;
                        permission.Gestion = item.Management;
                        permission.ModificadoPor = user.IdUsuario;
                        permission.FechaModificacion = datetime;
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

            return Forbid();
        }
    }
}

