using System.Text.Json;
using System.Text.Json.Serialization;


namespace TriadRestockSystem.Services
{
    public class CustomConverter<T> : JsonConverter<T>
    {
        public override T Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            if (reader.TokenType == JsonTokenType.Null)
            {
                return default!; // Return default value for the type (null for reference types, 0 for value types)
            }

            // Implement custom deserialization logic if needed
            return JsonSerializer.Deserialize<T>(ref reader, options)!; // Use ! to assert that the return value is not null
        }

        public override void Write(Utf8JsonWriter writer, T value, JsonSerializerOptions options)
        {
            // Implement custom serialization logic if needed
            JsonSerializer.Serialize(writer, value, options);
        }
    }

}
