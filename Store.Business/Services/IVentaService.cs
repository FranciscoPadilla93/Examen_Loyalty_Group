using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Business.Services
{
    public interface IVentaService
    {
        Task<bool> RegistrarVenta(Venta venta);
    }
}
