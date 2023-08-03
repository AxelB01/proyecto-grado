using System.ComponentModel.DataAnnotations;

namespace TriadRestockSystem.ViewModels
{
    public class vmSuppliers
    {
		
		public int Id { get; set; }
		public int IdEstado { get; set; }
		public int IdTipoProveedor { get; set; }
 		public string Nombre { get; set; } = string.Empty;
		public string RNC { get; set; } = string.Empty;
		public int IdPais { get; set; }
		public string Direccion { get; set; } = string.Empty;
		public string CodigoPostal { get; set; } = string.Empty;
		public string Telefono { get; set; } = string.Empty;
		public string Correo { get; set; } = string.Empty;


    }
}
