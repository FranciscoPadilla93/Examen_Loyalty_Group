using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Data.Repositories
{
    public interface IArticuloRepository
    {
        Task<IEnumerable<Articulo>> GetAll();
        Task<IEnumerable<Articulo>> GetByTienda(int idTienda);
        Task<bool> Create(Articulo articulo);
        Task<bool> Update(Articulo articulo);
        Task<bool> Delete(int id);
    }
}
