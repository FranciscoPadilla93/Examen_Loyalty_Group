using Store.Data.Repositories;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Business.Services
{
    public class CarritoService : ICarritoService
    {
        private readonly ICarritoRepository _repo;
        public CarritoService(ICarritoRepository repo) => _repo = repo;
        public async Task<IEnumerable<dynamic>> GetHistorialByCliente(int idCliente)
        {
            return await _repo.GetHistorial(idCliente);
        }
    }
}
