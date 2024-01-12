using System.Globalization;

namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmRequisicion
    {
        public int IdRequisicion { get; set; }
        public int Key
        {
            get { return IdRequisicion; }
        }
        public int IdAlmacen { get; set; }
        public string Almacen { get; set; } = string.Empty;
        public int IdDocumento { get; set; }
        public string Numero { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public DateTime? FechaAprobacion { get; set; }
        public string FechaAprobacionFormateada
        {
            get
            {
                string dateFormatted = FechaAprobacion.HasValue ? FechaAprobacion.Value.ToString("dddd d 'de' MMMM, yyyy", new CultureInfo("es-ES")) : "No disponible";
                string result = char.ToUpper(dateFormatted[0]) + dateFormatted[1..];

                return result;
            }
        }
        public DateTime? FechaArchivado { get; set; }
        public string FechaArchivadoFormateada
        {
            get
            {
                string dateFormatted = FechaArchivado.HasValue ? FechaArchivado.Value.ToString("dddd d 'de' MMMM, yyyy", new CultureInfo("es-ES")) : "No disponible";
                string result = char.ToUpper(dateFormatted[0]) + dateFormatted[1..];

                return result;
            }
        }
        public string AprobadoPorUsuario { get; set; } = string.Empty;
        public string AprobadoPor { get; set; } = string.Empty;
        public string ArchivadoPorUsuario { get; set; } = string.Empty;
        public string ArchivadoPor { get; set; } = string.Empty;

        public List<vmRequisicionDetalle> Detalles { get; set; } = new();
    }
}
