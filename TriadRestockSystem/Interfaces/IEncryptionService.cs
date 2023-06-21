namespace TriadRestockSystem.Interfaces
{
    public interface IEncryptionService
    {
        string AESEncrypt(string key, string iv, string inputText);
        string AESDecrypt(string key, string iv, string inputText);
    }
}
