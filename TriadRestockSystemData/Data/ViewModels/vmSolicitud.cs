namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmSolicitud
    {
        public int IdSolicitudMateriales { get; set; }
        public int IdDocumento { get; set; }
        public int IdCentroCosto { get; set; }
        public string CentroCosto { get; set; } = string.Empty;
        public string Numero { get; set; } = string.Empty;
        public DateTime Fecha { get; set; }
        public IdEstadoDocumento IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public int IdCreadoPor { get; set; }
        public string CreadoPor { get; set; } = string.Empty;
        public DateTime FechaCreacion { get; set; }
        public int? IdModificadoPor { get; set; }
        public string? ModificadoPor { get; set; }
        public DateTime? FechaModificacion { get; set; }
    }
}
