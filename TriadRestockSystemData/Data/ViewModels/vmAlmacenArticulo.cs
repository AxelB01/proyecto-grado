namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmAlmacenArticulo
    {
        public int IdAlmacen { get; set; }
        public int IdArticulo { get; set; }
        public string Key
        {
            get
            {
                return $"{IdAlmacen}-{IdArticulo}";
            }
        }
        public string Nombre { get; set; } = string.Empty;
        public decimal CantidadMinima { get; set; }
        public decimal CantidadMaxima { get; set; }
    }
}
