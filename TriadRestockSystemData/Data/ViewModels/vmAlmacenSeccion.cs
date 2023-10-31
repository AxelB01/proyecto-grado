namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmAlmacenSeccion
    {
        public int IdAlmacenSeccion { get; set; }
        public int Key
        {
            get
            {
                return IdAlmacenSeccion;
            }
        }
        public string Seccion { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;
        public int IdTipoZona { get; set; }
        public string TipoZonaAlmacenamiento { get; set; } = string.Empty;

        public List<vmAlmacenSeccionEstanteria> Estanterias { get; set; } = new List<vmAlmacenSeccionEstanteria>();
    }
}
