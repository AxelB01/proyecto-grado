using System.Globalization;

namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmAlmacenInventarioArticulo
    {
        public int IdInventario { get; set; }
        public int Key
        {
            get
            {
                return IdInventario;

            }
        }
        public int IdAlmacenSeccionEstanteria { get; set; }
        public string Estanteria { get; set; } = string.Empty;
        public int IdAlmacenSeccion { get; set; }
        public string Seccion { get; set; } = string.Empty;
        public int IdAlmacen { get; set; }
        public string Almacen { get; set; } = string.Empty;
        public int IdArticulo { get; set; }
        public string CodigoArticulo { get; set; } = string.Empty;
        public string Articulo { get; set; } = string.Empty;
        public string Descripcion { get; set; } = string.Empty;
        public string NumeroSerie { get; set; } = string.Empty;
        public int IdMarca { get; set; }
        public string Marca { get; set; } = string.Empty;
        public string Modelo { get; set; } = string.Empty;
        public decimal PrecioCompra { get; set; }
        public string Notas { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public int IdFamilia { get; set; }
        public string Familia { get; set; } = string.Empty;
        public int IdTipoArticulo { get; set; }
        public string Tipo { get; set; } = string.Empty;
        public int CreadoPor { get; set; }
        public string Login { get; set; } = string.Empty;
        public string NombreCompleto { get; set; } = string.Empty;
        public DateTime FechaRegistro { get; set; }
        public string FechaRegistroFormateada
        {
            get
            {
                return CultureInfo.InvariantCulture.TextInfo.ToTitleCase(FechaRegistro.ToString("dddd, MMMM dd, yyyy", new CultureInfo("es-ES")));
            }
        }
    }
}
