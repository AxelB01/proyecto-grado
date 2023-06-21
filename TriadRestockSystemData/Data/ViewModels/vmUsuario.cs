namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmUsuario
    {
        public int IdUsuario { get; set; }
        public string NombreCompleto { get; set; } = string.Empty;
        public string Login { get; set; } = string.Empty;
        public IdEstadoUsuario IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public string CreadoPor { get; set; } = string.Empty;
        public DateTime FechaCreacion { get; set; }
    }
}
