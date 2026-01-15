using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Data.Repositories
{
    public interface IVentaRepository
    {
        Task<bool> RegistrarVenta(Venta venta);
    }
}
