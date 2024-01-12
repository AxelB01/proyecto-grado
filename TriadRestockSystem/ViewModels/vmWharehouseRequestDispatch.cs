namespace TriadRestockSystem.ViewModels
{
    public class vmWharehouseRequestDispatch
    {
        public int IdAlmacen { get; set; }
        public int IdSolicitud { get; set; }
        public List<int> Detalles { get; set; } = new();
        public decimal Total { get; set; }
    }
}
