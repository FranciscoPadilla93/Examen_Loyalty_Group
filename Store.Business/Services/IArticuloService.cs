using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Business.Services
{
    public interface IArticuloService
    {
        Task<IEnumerable<Articulo>> ListarTodo();
        Task<IEnumerable<Articulo>> ListarPorTienda(int idTienda);
        Task<bool> NuevoArticulo(Articulo art);
        Task<bool> EditarArticulo(Articulo art);
        Task<bool> EliminarArticulo(int id);
    }
}
