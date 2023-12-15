namespace TriadRestockSystem.ViewModels
{
    public class vmWharehouseItemsSorting
    {
        public int Id { get; set; }
        public List<ItemSorting> Items { get; set; } = new();
    }

    public class ItemSorting
    {
        public int Articulo { get; set; }
        public int Minimo { get; set; }
        public int Maximo { get; set; }

    }
}
