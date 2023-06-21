using System.Security.Cryptography;
using System.Text;
using TriadRestockSystem.Interfaces;

namespace TriadRestockSystem.Services
{
    public class EncryptionService : IEncryptionService
    {
        private readonly Encoding encoding = Encoding.UTF8;
        public string AESDecrypt(string key, string iv, string inputText)
        {
            var inputData = Convert.FromBase64String(inputText);

            using var aes = Aes.Create();
            aes.Key = encoding.GetBytes(key);
            aes.IV = encoding.GetBytes(iv);
            aes.Mode = CipherMode.CBC;

            using var msEncrypt = new MemoryStream(inputData);
            using var cryptoStream = new CryptoStream(msEncrypt, aes.CreateDecryptor(), CryptoStreamMode.Read);
            using var outputData = new StreamReader(cryptoStream, encoding);

            var outputText = outputData.ReadToEnd();
            return outputText;
        }

        public string AESEncrypt(string key, string iv, string inputText)
        {
            var inputData = encoding.GetBytes(inputText);

            using var aes = Aes.Create();
            aes.Key = encoding.GetBytes(key);
            aes.IV = encoding.GetBytes(iv);
            aes.Mode = CipherMode.CBC;

            using var outputData = new MemoryStream();
            using var cs = new CryptoStream(outputData, aes.CreateEncryptor(), CryptoStreamMode.Write);
            cs.Write(inputData, 0, inputData.Length);
            cs.FlushFinalBlock();

            var outputText = Convert.ToBase64String(outputData.ToArray());
            return outputText;
        }
    }
}
