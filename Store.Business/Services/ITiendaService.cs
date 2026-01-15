using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Business.Services
{
    public interface ITiendaService
    {
        Task<IEnumerable<Tienda>> ListarTodas();
        Task<Tienda?> ObtenerPorId(int id);
        Task<bool> NuevaTienda(Tienda tienda);
        Task<bool> EditarTienda(Tienda tienda);
        Task<bool> EliminarTienda(int id);
    }
}
