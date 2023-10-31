namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmAlmacenSeccionEstanteriaArticuloExistencia
    {
        public int IdAlmacenSeccion { get; set; }
        public int IdAlmacenSeccionEstanteria { get; set; }
        public string Key
        {
            get
            {
                return $"{IdAlmacenSeccion}-{IdAlmacenSeccionEstanteria}-{Codigo}";
            }
        }
        public string Codigo { get; set; } = string.Empty;
        public int IdArticulo { get; set; }
        public string CodigoArticulo { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public int Existencias { get; set; }
    }
}
