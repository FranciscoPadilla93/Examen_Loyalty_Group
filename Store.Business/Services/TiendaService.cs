using Store.Data.Repositories;
using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Business.Services
{
    public class TiendaService : ITiendaService
    {
        private readonly ITiendaRepository _repo;
        public TiendaService(ITiendaRepository repo) => _repo = repo;

        public Task<IEnumerable<Tienda>> ListarTodas() => _repo.GetAll();

        public Task<Tienda?> ObtenerPorId(int id) => _repo.GetById(id);

        public async Task<bool> NuevaTienda(Tienda tienda)
        {
            if (string.IsNullOrEmpty(tienda.Sucursal)) return false;
            return await _repo.Create(tienda);
        }

        public Task<bool> EditarTienda(Tienda tienda) => _repo.Update(tienda);

        public Task<bool> EliminarTienda(int id) => _repo.Delete(id);
    }
}
