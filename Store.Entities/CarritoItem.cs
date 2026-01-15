using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Entities
{
    public class CarritoItem
    {
        public int IdArticulo { get; set; }
        public string ArticuloNombre { get; set; } = string.Empty;
        public int Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal => Cantidad * PrecioUnitario;
    }
}
