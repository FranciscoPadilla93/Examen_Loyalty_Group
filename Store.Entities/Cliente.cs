using System;
using System.Collections.Generic;
using System.Text;

namespace Store.Entities
{
    public class Cliente
    {
        public int IdCliente { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Apellidos { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty; // Solo para recibir del front
        public string Direccion { get; set; } = string.Empty;
        public bool Estatus { get; set; }
    }
}
