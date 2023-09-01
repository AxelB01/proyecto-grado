namespace TriadRestockSystem.ViewModels
{
    public class vmInventoryEntry
    {
        public int IdInventario { get; set; }
        public int IdArticulo { get; set; }
        public int IdAlmacenSeccionEstanteria { get; set; }
        public int IdOrdenCompra { get; set; }
        public string NumeroSerie { get; set; } = string.Empty;
        public string Modelo { get; set; } = string.Empty;
        public int IdMarca { get; set; }
        public int IdEstado { get; set; }
        public int IdImpuesto { get; set; }
        public decimal PrecioCompra { get; set; }
        public string FechaVencimiento { get; set; } = string.Empty;
        public string Notas { get; set; } = string.Empty;
    }
}
