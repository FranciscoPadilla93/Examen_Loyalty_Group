using Store.Data.Repositories;
using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Business.Services
{
    public class VentaService : IVentaService
    {
        private readonly IVentaRepository _ventaRepository;

        public VentaService(IVentaRepository ventaRepository)
        {
            _ventaRepository = ventaRepository;
        }

        public async Task<bool> RegistrarVenta(Venta venta)
        {
            return await _ventaRepository.RegistrarVenta(venta);
        }
    }
}
