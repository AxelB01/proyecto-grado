namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmOrdenCompraAlmacen
    {
        public int IdOrdenCompra { get; set; }
        public int Key
        {
            get
            {
                return IdOrdenCompra;
            }
        }
        public int IdDocumento { get; set; }
        public string Numero { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public int IdProveedor { get; set; }
        public string Proveedor { get; set; } = string.Empty;
        public DateTime FechaEntregaEstimada { get; set; }
    }
}
