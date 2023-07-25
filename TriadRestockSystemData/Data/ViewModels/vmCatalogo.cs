namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmCatalogo
    {
        public int IdCatalogo { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public int TotalArticulos { get; set; }
        public int IdCreadoPor { get; set; }
        public string CreadoPor { get; set; } = string.Empty;
        public DateTime FechaCreacion { get; set; }
        public int? IdModificadoPor { get; set; }
        public string? ModificadoPor { get; set; }
        public DateTime? FechaModificacion { get; set; }
    }
}
