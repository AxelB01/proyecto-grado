using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmProveedores
    {
        public int Id { get; set; }
		public int IdEstado { get; set; }
        public int IdTipoProveedor { get; set; }    
		public string Nombre { get; set; } = string.Empty;
 		public string RNC { get; set; } = string.Empty;
		public int IdPais { get; set; }
		public string Direccion { get; set; } = string.Empty;
		public string? CodigoPostal { get; set; } = string.Empty;
		public string Telefono { get; set; } = string.Empty;
		public string? Correo { get; set; } = string.Empty;
		//public DateTime? FechaUltimaCompra { get; set; }
        public string CreadoPor { get; set; } = string.Empty;
        public DateTime FechaCreacion { get; set; }
        public int? IdModificadoPor { get; set; }
        public string ModificadoPor { get; set; } = string.Empty;
        public DateTime? FechaModificacion { get; set; }
    }
}
