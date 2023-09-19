using TriadRestockSystemData.Data.Models;
using TriadRestockSystemData.Data.ViewModels;

namespace TriadRestockSystem.ViewModels
{
    public class Wharehouse
    {
        public vmWharehouse Almacen { get; set; } = new vmWharehouse();
        public List<vmSolicitudMaterialAlmacen> SolicitudesMateriales { get; set; } = new List<vmSolicitudMaterialAlmacen>();
        public List<OrdenesCompra> OrdenesCompras { get; set; } = new List<OrdenesCompra>();
        public List<vmAlmacenSeccion> Secciones { get; set; } = new List<vmAlmacenSeccion>();
    }
}
