namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmOrdenCompraAlmacenDetallesRegistro
    {
        public int IdOrdenCompra { get; set; }
        public int IdOrdenCompraDetalle { get; set; }
        public int Key
        {
            get
            {
                return IdOrdenCompraDetalle;
            }
        }
        public int IdArticulo { get; set; }
        public string Articulo { get; set; } = string.Empty;
        public int IdMarca { get; set; }
        public string Marca { get; set; } = string.Empty;
        public int IdFamilia { get; set; }
        public string Familia { get; set; } = string.Empty;
        public decimal Cantidad { get; set; }

    }
}
