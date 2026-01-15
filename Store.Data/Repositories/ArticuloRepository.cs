using Dapper;
using Store.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using static Store.Data.Context.Context;

namespace Store.Data.Repositories
{
    public class ArticuloRepository : IArticuloRepository
    {
        private readonly DapperContext _context;
        public ArticuloRepository(DapperContext context) => _context = context;

        public async Task<IEnumerable<Articulo>> GetAll()
        {
            using var connection = _context.CreateConnection();
            return await connection.QueryAsync<Articulo>("stp_Get_AllArticulos", commandType: CommandType.StoredProcedure);
        }
        public async Task<IEnumerable<Articulo>> GetByTienda(int idTienda)
        {
            using var conn = _context.CreateConnection();
            return await conn.QueryAsync<Articulo>("stp_Get_ArticulosByTienda", new { idTienda }, commandType: CommandType.StoredProcedure);
        }

        public async Task<bool> Create(Articulo art)
        {
            using var conn = _context.CreateConnection();
            var p = new DynamicParameters();
            p.Add("idTienda", art.IdTienda);
            p.Add("Codigo", art.Codigo);
            p.Add("Descripcion", art.Descripcion);
            p.Add("Precio", art.Precio);
            p.Add("Stock", art.Stock);
            p.Add("Success", dbType: DbType.Boolean, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("stp_Set_CreateArticulo", p, commandType: CommandType.StoredProcedure);
            return p.Get<bool>("Success");
        }

        public async Task<bool> Update(Articulo art)
        {
            using var conn = _context.CreateConnection();
            var p = new DynamicParameters();
            p.Add("idArticulo", art.IdArticulo);
            p.Add("idTienda", art.IdTienda);
            p.Add("Codigo", art.Codigo);
            p.Add("Descripcion", art.Descripcion);
            p.Add("Precio", art.Precio);
            p.Add("Stock", art.Stock);
            p.Add("Estatus", art.Estatus);
            p.Add("Success", dbType: DbType.Boolean, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("stp_Set_UpdateArticulo", p, commandType: CommandType.StoredProcedure);
            return p.Get<bool>("Success");
        }

        public async Task<bool> Delete(int id)
        {
            using var conn = _context.CreateConnection();
            var p = new DynamicParameters();
            p.Add("idArticulo", id);
            p.Add("Success", dbType: DbType.Boolean, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("stp_Set_DeleteArticulo", p, commandType: CommandType.StoredProcedure);
            return p.Get<bool>("Success");
        }
    }
}
