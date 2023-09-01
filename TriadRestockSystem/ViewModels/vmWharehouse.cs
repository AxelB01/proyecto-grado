namespace TriadRestockSystem.ViewModels
{
    public class vmWharehouse
    {
        public int IdAlmacen { get; set; }
        public int Key
        {
            get
            {
                return IdAlmacen;
            }
        }
        public string Nombre { get; set; } = string.Empty;
        public string Ubicacion { get; set; } = string.Empty;
        public decimal Espacio { get; set; }
        public string Descripcion { get; set; } = string.Empty;
        public int? IdEstado { get; set; }
        public string? Estado { get; set; }
    }
}
