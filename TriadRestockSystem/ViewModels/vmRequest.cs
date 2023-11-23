namespace TriadRestockSystem.ViewModels
{
    public class vmRequest
    {
        public int IdSolicitud { get; set; }
        public int IdCentroCosto { get; set; }
        public string CentroCosto { get; set; } = string.Empty;
        public string Numero { get; set; } = string.Empty;
        public string Fecha { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public string Justificacion { get; set; } = string.Empty;
        public string? Notas { get; set; }
        public int IdCreadoPor { get; set; }
        public string CreadoPor { get; set; } = string.Empty;
        public int IdRevisadoPor { get; set; }
        public string RevisadoPor { get; set; } = string.Empty;
        public RequestItem[] Detalles { get; set; } = Array.Empty<RequestItem>();
        public string? CausaRechazo { get; set; }
    }

    public class RequestItem
    {
        public int IdArticulo { get; set; }
        public string Articulo { get; set; } = string.Empty;
        public int Cantidad { get; set; }
        public int Existencia { get; set; } = 0;
    }
}
