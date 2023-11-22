using System.Globalization;

namespace TriadRestockSystem.ViewModels
{
    public class vmRequisition
    {
        public int IdRequisicion { get; set; }
        public int Key
        {
            get
            {
                return IdRequisicion;
            }
        }
        public int IdDocumento { get; set; }
        public string Numero { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public DateTime? Fecha { get; set; }
        public string FechaFormateada
        {
            get
            {
                return Fecha != null ? Fecha.Value.ToString("dddd d 'de' MMMM, yyyy", new CultureInfo("es-ES")) : "";
            }
        }
        public int IdAlmacen { get; set; }
        public List<RequisitionItem> Articulos { get; set; } = new List<RequisitionItem>();
    }

    public class RequisitionItem
    {
        public int IdArticulo { get; set; }
        public string Key { get; set; } = string.Empty;
        public string Articulo { get; set; } = string.Empty;
        public string Codigo { get; set; } = string.Empty;
        public int IdFamilia { get; set; }
        public string Familia { get; set; } = string.Empty;
        public int IdUnidadMedida { get; set; }
        public string UnidadMedida { get; set; } = string.Empty;
        public int Cantidad { get; set; }
    }
}
