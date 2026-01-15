using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Entities
{
    public class Articulo
    {
        public int IdArticulo { get; set; }
        public int IdTienda { get; set; }
        public string Codigo { get; set; } = string.Empty;
        public string Descripcion { get; set; } = string.Empty;
        public decimal Precio { get; set; }
        public int Stock { get; set; }
        public bool Estatus { get; set; }
        public string? SucursalNombre { get; set; }
    }
}
