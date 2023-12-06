namespace TriadRestockSystem.ViewModels
{
    public class vmRole
    {
        public int IdRole { get; set; }
        public string Role { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
    }

    public class vmRolePermissions
    {
        public int IdRole { get; set; }
        public List<vmPermission> Permissions { get; set; } = new List<vmPermission>();
    }

    public class vmPermission
    {
        public int Id { get; set; }
        public bool View { get; set; }
        public bool Creation { get; set; }
        public bool Management { get; set; }
    }
}
