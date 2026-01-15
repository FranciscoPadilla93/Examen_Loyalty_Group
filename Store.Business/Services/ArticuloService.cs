using Store.Data.Repositories;
using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Business.Services
{
    public class ArticuloService : IArticuloService
    {
        private readonly IArticuloRepository _repo;
        public ArticuloService(IArticuloRepository repo) => _repo = repo;

        public Task<IEnumerable<Articulo>> ListarTodo() => _repo.GetAll();

        public Task<IEnumerable<Articulo>> ListarPorTienda(int idTienda) => _repo.GetByTienda(idTienda);

        public async Task<bool> NuevoArticulo(Articulo art)
        {
            if (art.Precio < 0 || art.Stock < 0) return false;
            return await _repo.Create(art);
        }

        public async Task<bool> EditarArticulo(Articulo art)
        {
            if (art.IdArticulo <= 0) return false;
            return await _repo.Update(art);
        }

        public Task<bool> EliminarArticulo(int id) => _repo.Delete(id);
    }
}
