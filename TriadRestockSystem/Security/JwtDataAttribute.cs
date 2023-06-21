namespace TriadRestockSystem.Security
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = false)]
    public class JwtDataAttribute : Attribute
    {
    }
}
