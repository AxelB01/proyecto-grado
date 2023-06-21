using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace TriadRestockSystem.Security
{
    public class JwtDataMiddleware
    {
        private readonly RequestDelegate _next;

        public JwtDataMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            if (context.Request.Headers.TryGetValue("Authorization", out var authHeader)
                && authHeader.FirstOrDefault()?.StartsWith("Bearer ") == true)
            {
                var token = authHeader.FirstOrDefault()?.Replace("Bearer ", "");
                var jwtToken = new JwtSecurityToken(token);

                var username = jwtToken.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Name)?.Value;
                var password = jwtToken.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Surname)?.Value;

                context.Items["Username"] = username;
                context.Items["Password"] = password;
            }

            await _next(context);
        }
    }
}
