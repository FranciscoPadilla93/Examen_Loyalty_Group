using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Store.Data.Repositories;
using Store.Entities;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Store.Business.Services
{
    public class AuthService : IAuthService
    {
        private readonly IClienteRepository _clienteRepo;
        private readonly IConfiguration _config;

        public AuthService(IClienteRepository clienteRepo, IConfiguration config)
        {
            _clienteRepo = clienteRepo;
            _config = config;
        }

        public async Task<bool> Registrar(Cliente cliente)
        {
            // Hasheo de contraseña antes de guardar en DB
            cliente.Password = BCrypt.Net.BCrypt.HashPassword(cliente.Password);
            return await _clienteRepo.RegisterCliente(cliente);
        }

        public async Task<string?> Login(string email, string password)
        {
            var cliente = await _clienteRepo.GetClienteByEmail(email);

            // Si el cliente no existe o la contraseña no coincide con el Hash
            if (cliente == null || !BCrypt.Net.BCrypt.Verify(password, cliente.Password))
                return null;

            return GenerarTokenJWT(cliente);
        }

        private string GenerarTokenJWT(Cliente cliente)
        {
            var key = Encoding.ASCII.GetBytes(_config["Jwt:Key"]!);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                {
                    new Claim(ClaimTypes.NameIdentifier, cliente.IdCliente.ToString()),
                    new Claim(ClaimTypes.Email, cliente.Email),
                    new Claim(ClaimTypes.Name, cliente.Nombre)
                }),
                Expires = DateTime.UtcNow.AddHours(8),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }
    }
}
