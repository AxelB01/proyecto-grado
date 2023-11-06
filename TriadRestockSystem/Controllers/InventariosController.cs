using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TriadRestockSystem.Security;
using TriadRestockSystem.ViewModels;
using TriadRestockSystemData.Data;
using TriadRestockSystemData.Data.Models;

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
            var login = HttpContext.Items["Username"] as string;
            var pass = HttpContext.Items["Password"] as string;

            Usuario? user = _db.Usuarios.FirstOrDefault(u => u.Login.Equals(login) && u.Password!.Equals(pass));

            if (user != null)
            {
                var existingItem = _db.Inventarios
                    .Where(i =>
                        i.IdArticulo == model.IdArticulo
                        && i.NumeroSerie == model.NumeroSerie
                        && i.IdEstado == 1
                    )
                    .FirstOrDefault();

                if (existingItem == null)
                {
                    using var dbTran = _db.Database.BeginTransaction();
                    try
                    {
                        var inventoryEntry = new Inventario();

                        inventoryEntry.IdArticulo = model.IdArticulo;
                        inventoryEntry.IdAlmacenSeccionEstanteria = model.IdAlmacenSeccionEstanteria;
                        inventoryEntry.NumeroSerie = model.NumeroSerie;
                        inventoryEntry.Modelo = model.Modelo;
                        inventoryEntry.IdMarca = model.IdMarca;
                        inventoryEntry.IdEstado = model.IdEstado;
                        inventoryEntry.IdImpuesto = model.IdImpuesto;
                        inventoryEntry.PrecioCompra = model.PrecioCompra;
                        inventoryEntry.Notas = model.Notas;
                        inventoryEntry.CreadoPor = user.IdUsuario;
                        inventoryEntry.FechaRegistro = DateTime.Now;

                        _db.Inventarios.Add(inventoryEntry);
                        _db.SaveChanges();

                        dbTran.Commit();

                        return Ok(new { status = "Ok" });
                    }
                    catch (Exception e)
                    {
                        dbTran.Rollback();
                        return StatusCode(StatusCodes.Status500InternalServerError, e.ToString());
                    }
                }
                else
                {
                    return Ok(new { status = "El artículo ya existe" });
                }
            }

            return Forbid();
        }
    }
}
