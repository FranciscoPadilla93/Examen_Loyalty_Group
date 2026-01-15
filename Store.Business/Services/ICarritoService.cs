using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Business.Services
{
    public interface ICarritoService
    {
        Task<IEnumerable<dynamic>> GetHistorialByCliente(int idCliente);
    }
}
