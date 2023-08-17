using Dapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Storage;
using System.Data;
using TriadRestockSystem.ViewModels;
using TriadRestockSystemData.Data.ViewModels;

namespace TriadRestockSystemData.Data
{
    public static partial class InventarioDBContextExtensions
    {
        public static IList<vmUsuario> UsuariosGetAll(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmUsuario>("UsuariosGetAll", commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmSolicitud> SolicitudesGetAll(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmSolicitud>("SolicitudesGetAll", commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmArticuloListItem> ArticulosGetList(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmArticuloListItem>("ArticulosGetList", commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static string DocumentoGetNumero(this InventarioDBContext context, int tipoDocumento)
        {
            return context.Database.GetDbConnection()
                .QueryFirst<string>($"SELECT dbo.DocumentoGetNumero({tipoDocumento})", transaction: context.Database.CurrentTransaction!.GetDbTransaction(), commandType: CommandType.Text);
        }

        public static IList<vmCentroCosto> CentrosCostosGetAll(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmCentroCosto>("CentrosCostosGetAll", commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmArticulo> ArticulosGetAll(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmArticulo>("ArticulosGetAll", commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmCatalogo> CatalogosGetAll(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmCatalogo>("CatalogosGetAll", commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmAlmacen> AlmacenesGetAll(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmAlmacen>("AlmacenesGetAll", commandType: CommandType.StoredProcedure)
                .ToList();
        }
    }
}
