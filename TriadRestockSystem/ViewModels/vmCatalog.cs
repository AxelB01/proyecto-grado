namespace TriadRestockSystem.ViewModels
{
    public class vmCatalog
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public List<int> IdsCentrosCostos { get; set; } = new();
        public List<int> Detalle { get; set; } = new();
    }
}
