namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmRequisicionDetalle
    {
        public int IdRequisicionDetalle { get; set; }
        public int Key
        {
            get { return IdRequisicionDetalle; }
        }
        public int IdRequisicion { get; set; }
        public int IdArticulo { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public string Articulo { get; set; } = string.Empty;
        public int IdUnidadMedida { get; set; }
        public string UnidadMedida { get; set; } = string.Empty;
        public int IdMarca { get; set; }
        public string Marca { get; set; } = string.Empty;
        public int IdFamilia { get; set; }
        public string Familia { get; set; } = string.Empty;
        public decimal Cantidad { get; set; }
        public decimal PrecioBase { get; set; }
        public string Impuesto { get; set; } = string.Empty;
        public decimal ImpuestoDecimal { get; set; }
    }
}
