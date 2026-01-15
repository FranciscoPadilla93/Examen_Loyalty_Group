using Dapper;
using Microsoft.Data.SqlClient;
using Store.Data.Context;
using Store.Entities;
using System;
using System.Collections.Generic;
using System.Text;
using static Store.Data.Context.Context;

namespace Store.Data.Repositories
{
    public class CarritoRepository : ICarritoRepository
    {
        private readonly DapperContext _context;
        public CarritoRepository(DapperContext context) => _context = context;
        public async Task<IEnumerable<dynamic>> GetHistorial(int idCliente)
        {
            using var connection = _context.CreateConnection();
            return await connection.QueryAsync<dynamic>(
                @"SELECT idCarrito, fechaAdd, total, estatus 
          FROM CarritoCompras 
          WHERE idCliente = @IdCliente 
          ORDER BY fechaAdd DESC",
                new { IdCliente = idCliente }
            );
        }
    }
}
