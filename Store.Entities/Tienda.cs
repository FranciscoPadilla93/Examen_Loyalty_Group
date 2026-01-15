using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Entities
{
    public class Tienda
    {
        public int IdTienda { get; set; }
        public string Sucursal { get; set; } = string.Empty;
        public string Direccion { get; set; } = string.Empty;
        public bool Estatus { get; set; }
    }
}
