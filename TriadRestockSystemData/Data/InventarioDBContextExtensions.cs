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

        public static IList<vmArticuloListItem> ArticulosGetList(this InventarioDBContext context, int id)
        {
            return context.Database.GetDbConnection()
                .Query<vmArticuloListItem>("ArticulosGetList", new { id }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        //public static IList<vmProveedores> ProveedoresGetAll(this InventarioDBContext context)
        //{
        //    return context.Database.GetDbConnection()
        //       .Query<vmProveedores>("ProveedoresGetAll", commandType: CommandType.StoredProcedure)
        //       .ToList();
        //}

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

        //public static IList<vmAlmacenSeccionEstanteriasExistencias> AlmacenSeccionEstanteriasExistenciasByIdSeccion(this InventarioDBContext context, int idSec)
        //{
        //    return context.Database.GetDbConnection()
        //        .Query<vmAlmacenSeccionEstanteriasExistencias>("AlmacenSeccionEstanteriasExistenciasByIdSeccion", new { idSec }, commandType: CommandType.StoredProcedure)
        //        .ToList();
        //}

        public static IList<vmSolicitudMaterialAlmacen> SolicitudesMaterialesByIdAlm(this InventarioDBContext context, int idAlm)
        {
            return context.Database.GetDbConnection()
                .Query<vmSolicitudMaterialAlmacen>("SolicitudesMaterialesByIdAlm", new { idAlm }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmAlmacenArticulo> AlmacenArticulosGet(this InventarioDBContext context, int idAlmacen)
        {
            return context.Database.GetDbConnection()
                .Query<vmAlmacenArticulo>("AlmacenArticulosGet", new { idAlmacen }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmAlmacenSeccionEstanteriaArticuloExistencia> AlmacenSeccionEstanteriasArticulosExistenciasGetByIdAlmacen(this InventarioDBContext context, int idAlmacen)
        {
            return context.Database.GetDbConnection()
                .Query<vmAlmacenSeccionEstanteriaArticuloExistencia>("AlmacenSeccionEstanteriasArticulosExistenciasGetByIdAlmacen", new { idAlmacen }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmAlmacenInventarioArticulo> InventarioAlmacen(this InventarioDBContext context, int idAlm)
        {
            return context.Database.GetDbConnection()
                .Query<vmAlmacenInventarioArticulo>("InventarioAlmacen", new { idAlm }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmRequisicionAlmacenArticulo> RequisicionGetItemsById(this InventarioDBContext context, int id)
        {
            return context.Database.GetDbConnection()
                .Query<vmRequisicionAlmacenArticulo>("RequisicionGetItemsById", new { id }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmAlmacenPersonal> AlmacenGetPersonal(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmAlmacenPersonal>("AlmacenGetPersonal", commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmAlmacenArticuloExistencias> InventarioAlmacenArticulosExistencias(this InventarioDBContext context, int id)
        {
            return context.Database.GetDbConnection()
                .Query<vmAlmacenArticuloExistencias>("InventarioAlmacenArticulosExistencias", new { id }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmRequisicion> RequisicionesGetAll(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmRequisicion>("RequisicionesGetAll", commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmRequisicionDetalle> RequisicionDetallesGetById(this InventarioDBContext context, int id)
        {
            return context.Database.GetDbConnection()
                .Query<vmRequisicionDetalle>("RequisicionDetallesGetById", new { id }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmArticuloListItemPO> ListaArticulosOrdenCompra(this InventarioDBContext context)
        {
            return context.Database.GetDbConnection()
                .Query<vmArticuloListItemPO>("ListaArticulosOrdenCompra", commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmOrdenCompraAlmacen> OrdenesCompraByIdAlmacen(this InventarioDBContext context, int id)
        {
            return context.Database.GetDbConnection()
                .Query<vmOrdenCompraAlmacen>("OrdenesCompraByIdAlmacen", new { id }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmOrdenCompraAlmacenDetallesRegistro> OrdenCompraAlmacenArticulosGetByIdOrden(this InventarioDBContext context, int id)
        {
            return context.Database.GetDbConnection()
                .Query<vmOrdenCompraAlmacenDetallesRegistro>("OrdenCompraAlmacenArticulosGetByIdOrden", new { id }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmSolicitudMaterialesAlmacen> SolicitudesMaterialesByIdAlmacen(this InventarioDBContext context, int id)
        {
            return context.Database.GetDbConnection()
                .Query<vmSolicitudMaterialesAlmacen>("SolicitudesMaterialesByIdAlmacen", new { id }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmSolicitudMaterialesDespachoDetalle> SolicitudMaterialesDespachoAlmacenDetalles(this InventarioDBContext context, int idSolicitud, int idAlmacen)
        {
            return context.Database.GetDbConnection()
                .Query<vmSolicitudMaterialesDespachoDetalle>("SolicitudMaterialesDespachoAlmacenDetalles", new { idSolicitud, idAlmacen }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static IList<vmInventarioAlmacenArticuloDespacho> InventarioAlmacenDespachoSolicitud(this InventarioDBContext context, int id)
        {
            return context.Database.GetDbConnection()
                .Query<vmInventarioAlmacenArticuloDespacho>("InventarioAlmacenDespachoSolicitud", new { id }, commandType: CommandType.StoredProcedure)
                .ToList();
        }

        public static string DocumentoGetNumero(this InventarioDBContext context, int tipoDocumento)
        {
            return context.Database.GetDbConnection()
                .QueryFirst<string>($"SELECT dbo.DocumentoGetNumero({tipoDocumento})", transaction: context.Database.CurrentTransaction!.GetDbTransaction(), commandType: CommandType.Text);
        }

        public static string ConceptoGetCodigoAgrupador(this InventarioDBContext context, int id)
        {
            return context.Database.GetDbConnection()
                .QueryFirst<string>($"SELECT dbo.ConceptoGetCodigoAgrupador({id})", transaction: context.Database.CurrentTransaction!.GetDbTransaction(), commandType: CommandType.Text);
        }

        public static void RolesModulosSetUp(this InventarioDBContext context, int idRol)
        {
            context.Database.GetDbConnection().Execute("RolesModulosSetUp", new { idRol }, context.Database.CurrentTransaction?.GetDbTransaction(), commandType: CommandType.StoredProcedure);
        }

    }
}
