using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Entities
{
    public class Venta
    {
        public int IdCliente { get; set; }
        public decimal Total { get; set; }
        public List<VentaDetalle> Detalles { get; set; }
    }

    public class VentaDetalle
    {
        public int IdArticulo { get; set; }
        public int Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal { get; set; }
    }

    public class CarritoDTO
    {
        public int IdCliente { get; set; }
        public decimal Total { get; set; }
        public List<CarritoDetalleDTO> Detalles { get; set; }
    }

    public class CarritoDetalleDTO
    {
        public int IdArticulo { get; set; }
        public int Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal { get; set; }
    }
}
