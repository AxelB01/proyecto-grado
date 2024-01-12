namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmArticuloListItemPO
    {
        public int IdArticulo { get; set; }
        public int Key
        {
            get { return IdArticulo; }
        }
        public string Codigo { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public decimal PrecioBase { get; set; }
        public int IdImpuesto { get; set; }
        public string Impuesto { get; set; } = string.Empty;
        public decimal ImpuestoDecimal { get; set; }
        public int IdMarca { get; set; }
        public string Marca { get; set; } = string.Empty;
        public int IdFamilia { get; set; }
        public string Familia { get; set; } = string.Empty;
        public int IdTipoArticulo { get; set; }
        public string TipoArticulo { get; set; } = string.Empty;
        public int IdUnidadMedida { get; set; }
        public string UnidadMedida { get; set; } = string.Empty;
        public string NombreCompleto
        {
            get
            {
                return $"{Nombre} | {Marca} ({UnidadMedida})";
            }
        }
    }
}
