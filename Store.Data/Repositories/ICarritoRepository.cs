using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Data.Repositories
{
    public interface ICarritoRepository
    {
        Task<IEnumerable<dynamic>> GetHistorial(int idCliente);
    }
}
