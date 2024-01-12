namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmArticulo
    {
        public int IdArticulo { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public int IdUnidadMedida { get; set; }
        public string UnidadMedida { get; set; } = string.Empty;
        public string CodigoUnidadMedida { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public int IdMarca { get; set; }
        public string Marca { get; set; } = string.Empty;
        public decimal PrecioBase { get; set; }
        public int IdImpuesto { get; set; }
        public string Impuesto { get; set; } = string.Empty;
        public decimal ImpuestoDecimal { get; set; }
        public string Descripcion { get; set; } = string.Empty;
        public int IdFamilia { get; set; }
        public string Familia { get; set; } = string.Empty;
        public int IdTipoArticulo { get; set; }
        public string Tipo { get; set; } = string.Empty;
        public bool ConsumoGeneral { get; set; }
        public int NumeroReorden { get; set; }
        public int IdCreadoPor { get; set; }
        public string CreadoPor { get; set; } = string.Empty;
        public DateTime FechaCreacion { get; set; }
        public int? IdModificadoPor { get; set; }
        public string ModificadoPor { get; set; } = string.Empty;
        public DateTime? FechaModificacion { get; set; }

    }
}
