using TriadRestockSystemData.Data.Models;
using TriadRestockSystemData.Data.ViewModels;

namespace TriadRestockSystem.ViewModels
{
    public class Wharehouse
    {
        public vmWharehouse Almacen { get; set; } = new vmWharehouse();
        public List<vmSolicitudMaterialAlmacen> SolicitudesMateriales { get; set; } = new();
        public List<vmRequisition> Requisiciones { get; set; } = new();
        public List<OrdenesCompra> OrdenesCompras { get; set; } = new();
        public List<vmAlmacenSeccion> Secciones { get; set; } = new();
        public List<vmAlmacenArticulo> Articulos { get; set; } = new();
        public List<vmAlmacenFamilia> Familias { get; set; } = new();
        public List<vmAllowedItem> ArticulosPermitidos { get; set; } = new();
        public List<ItemSorting> ArticulosOrdenamiento { get; set; } = new();
    }

    public class vmAllowedItem
    {
        public int IdArticulo { get; set; }
        public int Key
        {
            get
            {
                return IdArticulo;
            }
        }
        public string Codigo { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
    }
}
