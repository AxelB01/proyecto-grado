namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmAlmacenSeccionEstanteriasExistencias
    {
        public int IdAlmacenSeccionEstanteria { get; set; }
        public int Key
        {
            get
            {
                return IdAlmacenSeccionEstanteria;
            }
        }
        public string Codigo { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public int IdArticulo { get; set; }
        public string Articulo { get; set; } = string.Empty;
        public string CodigoArticulo { get; set; } = string.Empty;
        public string UnidadMedida { get; set; } = string.Empty;
        public int CapacidadMaxima { get; set; }
        public int MinimoRequerido { get; set; }
        public int Existencias { get; set; }
    }
}
