namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmAlmacen
    {
        public int IdAlmacen { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Ubicacion { get; set; } = string.Empty;
        public decimal Espacio { get; set; }
        public string Descripcion { get; set; } = string.Empty;
        public int IdCreadoPor { get; set; }
        public string CreadoPor { get; set; } = string.Empty;
        public DateTime FechaCreacion { get; set; }
        public int? IdModificadoPor { get; set; }
        public string? ModificadoPor { get; set; } = string.Empty;
        public DateTime? FechaModificacion { get; set; }
    }
}
