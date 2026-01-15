using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Data.Repositories
{
    public interface IClienteRepository
    {
        Task<Cliente?> GetClienteByEmail(string email);
        Task<bool> RegisterCliente(Cliente cliente);
    }
}
