namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmAlmacenSeccionEstanteria
    {
        public int IdAlmacenSeccionEstanteria { get; set; }
        public int Key
        {
            get
            {
                return IdAlmacenSeccionEstanteria;
            }
        }
        public int IdAlmacenSeccion { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public int IdEstado { get; set; }
        public string Estado { get; set; } = string.Empty;

        public List<vmAlmacenSeccionEstanteriaArticuloExistencia> Existencias { get; set; } = new List<vmAlmacenSeccionEstanteriaArticuloExistencia>();
    }

}
