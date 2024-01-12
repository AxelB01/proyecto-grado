namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmSolicitudMaterialesDespachoDetalle
    {
        public int IdSolicitudMaterialesDetalle { get; set; }
        public int Key
        {
            get
            {
                return IdSolicitudMaterialesDetalle;
            }
        }
        public int IdSolicitudMateriales { get; set; }
        public int IdArticulo { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public string Articulo { get; set; } = string.Empty;
        public int IdMarca { get; set; }
        public string Marca { get; set; } = string.Empty;
        public int IdFamilia { get; set; }
        public string Familia { get; set; } = string.Empty;
        public string ArticuloCompleto
        {
            get
            {
                return $"{Articulo} ({Marca})";
            }
        }
        public decimal CantidadRequerida { get; set; }
        public int Existencias { get; set; }
        public decimal Costo { get; set; }
    }
}
