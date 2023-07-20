using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmArticulo
    {
        public int IdArticulo { get; set; }
        public int IdUnidadMedida { get; set; }
        //public string Unidad { get; set; } = string.Empty;
        public string Codigo { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string? Descripcion { get; set; } = string.Empty;
        public int IdFamilia { get; set; }
        //public string Familia { get;set; } = string.Empty; 
        public int IdTipoArticulo { get; set; }  
        //public string TipoArticulo { get; set; } = string.Empty;
        public string? CreadoPor { get; set; } = string.Empty;
        public string? FechaCreacion { get; set; }
    }
}
