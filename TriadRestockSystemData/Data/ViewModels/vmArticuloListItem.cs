namespace TriadRestockSystemData.Data.ViewModels
{
    public class vmArticuloListItem
    {
        public int IdArticulo { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public string Nombre { get; set; } = string.Empty;
        public string UnidadMedida { get; set; } = string.Empty;
        public int Existencias { get; set; }
    }
}
