namespace TriadRestockSystem.ViewModels
{
    public class vmUser
    {
        public int? Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Login { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public int State { get; set; }
        public int[] Roles { get; set; } = Array.Empty<int>();
        public int[] CostCenters { get; set; } = Array.Empty<int>();

    }
}
