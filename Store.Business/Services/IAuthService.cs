using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Business.Services
{
    public interface IAuthService
    {
        Task<bool> Registrar(Cliente cliente);
        Task<string?> Login(string email, string password); 
    }

}
