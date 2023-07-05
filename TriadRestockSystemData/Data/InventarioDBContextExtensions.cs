using Dapper;
using Microsoft.EntityFrameworkCore;
using System.Data;
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

        public static IList<vmSolicitudes> SolicitudesGetAll(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmSolicitudes>("SolicitudesGetAll", commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmArticuloListItem> ArticulosGetList(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmArticuloListItem>("ArticulosGetList", commandType: CommandType.StoredProcedure)
                .ToList();
        }
    }
}
