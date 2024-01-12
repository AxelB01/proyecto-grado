namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmSolicitudMaterialesAlmacen
    {
        public int IdSolicitudMateriales { get; set; }
        public int Key
        {
            get
            {
                return IdSolicitudMateriales;
            }
        }
        public int IdDocumento { get; set; }
        public string Numero { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public int IdCentroCosto { get; set; }
        public string CentroCosto { get; set; } = string.Empty;
        public DateTime FechaAprobacion { get; set; }
    }
}
