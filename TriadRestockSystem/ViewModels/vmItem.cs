namespace TriadRestockSystem.ViewModels
{
    public class vmItem
    {
        public int IdArticulo { get; set; }
        public int IdUnidadMedida { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public int IdMarca { get; set; }
        public string Marca { get; set; } = string.Empty;
        public string? Descripcion { get; set; } = string.Empty;
        public int IdFamilia { get; set; }
        public int IdTipoArticulo { get; set; }
        public decimal Precio { get; set; }
        public bool ConsumoGeneral { get; set; }
    }
}
