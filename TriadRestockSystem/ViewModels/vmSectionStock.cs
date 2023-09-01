namespace TriadRestockSystem.ViewModels
{
    public class vmSectionStock
    {
        public int IdSeccion { get; set; }
        public int IdEstanteria { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public int IdArticulo { get; set; }
        public int Maximo { get; set; }
        public int Minimo { get; set; }
    }
}
