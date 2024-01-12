namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmInventarioAlmacenArticuloDespacho
    {
        public int IdInventario { get; set; }
        public int IdArticulo { get; set; }
        public string Articulo { get; set; } = string.Empty;
        public int IdMarca { get; set; }
        public string Marca { get; set; } = string.Empty;
        public string Codigo { get; set; } = string.Empty;
        public DateTime? FechaVencimiento { get; set; }
        public string? Notas { get; set; }
        public DateTime FechaRegistro { get; set; }
    }
}
