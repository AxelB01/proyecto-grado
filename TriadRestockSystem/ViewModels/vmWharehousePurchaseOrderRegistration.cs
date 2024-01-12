namespace TriadRestockSystem.ViewModels
{
    public class vmWharehousePurchaseOrderRegistration
    {
        public int IdOrden { get; set; }
        public List<vmWharehousePurchaseOrderRegistrationItem> Articulos { get; set; } = new();
    }

    public class vmWharehousePurchaseOrderRegistrationItem
    {
        public int IdArticulo { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public int Posicion { get; set; }
        public string? Notas { get; set; }
    }
}
