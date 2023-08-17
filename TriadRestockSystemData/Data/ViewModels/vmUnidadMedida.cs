using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmUnidadMedida
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string? Codigo { get; set; } = string.Empty;
    }
}
