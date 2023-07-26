namespace TriadRestockSystem.ViewModels
{
    public class vmCostCenter
    {
        public int IdCentroCosto { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Cuenta { get; set; } = string.Empty;
        public int IdCreadoPor { get; set; }
        public string CreadoPor { get; set; } = string.Empty;
        public string FechaCreacion { get; set; } = string.Empty;
        public int? IdModificadoPor { get; set; }
        public string? ModificadoPor { get; set; }
        public string? FechaModificacion { get; set; }
    }
}
