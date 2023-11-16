namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmRequisicionAlmacenArticulo
    {
        public int IdArticulo { get; set; }
        public int Key
        {
            get
            {
                return IdArticulo;
            }
        }
        public string Articulo { get; set; } = string.Empty;
        public string Codigo { get; set; } = string.Empty;
        public int IdUnidadMedida { get; set; }
        public string UnidadMedida { get; set; } = string.Empty;
        public int IdFamilia { get; set; }
        public string Familia { get; set; } = string.Empty;
        public int Cantidad { get; set; }
    }
}
