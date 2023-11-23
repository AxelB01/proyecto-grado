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
        public List<Employee> Personal { get; set; } = new();
        public List<int> IdsPersonal { get; set; } = new();
        public int IdCreadoPor { get; set; }
        public string CreadoPor { get; set; } = string.Empty;
        public string CreadorPorNombreCompleto { get; set; } = string.Empty;
        public string Fecha { get; set; } = string.Empty;
    }

    public class Employee
    {
        public int IdUsuario { get; set; }
        public int Key
        {
            get
            {
                return IdUsuario;
            }
        }
        public string Username { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Role { get; set; } = string.Empty;
    }
}
