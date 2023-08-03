namespace TriadRestockSystem.ViewModels
{
    public class vmWharehouse
    {
        public int IdAlmacen { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Ubicacion { get; set; } = string.Empty;
        public decimal Espacio { get; set; }
        public string Descripcion { get; set; } = string.Empty;
    }
}
