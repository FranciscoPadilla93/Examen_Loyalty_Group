using Dapper;
using Store.Entities;
using System.Data;
using static Store.Data.Context.Context;

namespace Store.Data.Repositories
{
    public class TiendaRepository : ITiendaRepository
    {
        private readonly DapperContext _context;
        public TiendaRepository(DapperContext context) => _context = context;

        public async Task<IEnumerable<Tienda>> GetAll()
        {
            using var connection = _context.CreateConnection();
            return await connection.QueryAsync<Tienda>("stp_Get_AllStore", commandType: CommandType.StoredProcedure);
        }

        public async Task<Tienda?> GetById(int idTienda)
        {
            using var conn = _context.CreateConnection();
            return await conn.QueryFirstOrDefaultAsync<Tienda>("stp_Get_StoreByID", new { idTienda }, commandType: CommandType.StoredProcedure);
        }

        public async Task<bool> Create(Tienda t)
        {
            using var conn = _context.CreateConnection();
            var p = new DynamicParameters();
            p.Add("Nombre", t.Sucursal);
            p.Add("Direccion", t.Direccion);
            p.Add("Success", dbType: DbType.Boolean, direction: ParameterDirection.Output);

            p.Add("idTienda", dbType: DbType.Int32, direction: ParameterDirection.Output);
            p.Add("Success", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Message", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await conn.ExecuteAsync("stp_Set_CreateStore", p, commandType: CommandType.StoredProcedure);
            return p.Get<bool>("Success");
        }

        public async Task<bool> Update(Tienda t)
        {
            using var conn = _context.CreateConnection();
            var p = new DynamicParameters();
            p.Add("idTienda", t.IdTienda);
            p.Add("Nombre", t.Sucursal);
            p.Add("Direccion", t.Direccion);
            p.Add("Estatus", t.Estatus);
            p.Add("Success", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Message", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);
            await conn.ExecuteAsync("stp_Set_UpdateStore", p, commandType: CommandType.StoredProcedure);
            return p.Get<bool>("Success");
        }

        public async Task<bool> Delete(int id)
        {
            using var conn = _context.CreateConnection();
            var p = new DynamicParameters();
            p.Add("idTienda", id);
            p.Add("Success", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            p.Add("Message", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);
            await conn.ExecuteAsync("stp_Set_DeleteStore", p, commandType: CommandType.StoredProcedure);
            return p.Get<bool>("Success");
        }
    }
}
