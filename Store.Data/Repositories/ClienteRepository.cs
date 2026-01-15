using Dapper;
using Store.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using static Store.Data.Context.Context;

namespace Store.Data.Repositories
{
    public class ClienteRepository : IClienteRepository
    {
        private readonly DapperContext _context;
        public ClienteRepository(DapperContext context) => _context = context;

            public async Task<Cliente?> GetClienteByEmail(string email)
            {
                using var connection = _context.CreateConnection();
                return await connection.QueryFirstOrDefaultAsync<Cliente>(
                    "SELECT idCliente, Nombre, Email, PasswordHash as Password, Estatus FROM Clientes WHERE Email = @Email",
                    new { Email = email }
                );
            }

        public async Task<bool> RegisterCliente(Cliente cliente)
        {
            using var connection = _context.CreateConnection();

            var parameters = new DynamicParameters();
            parameters.Add("Nombre", cliente.Nombre);
            parameters.Add("Apellido", cliente.Apellidos);
            parameters.Add("Email", cliente.Email);
            parameters.Add("Password", cliente.Password);
            parameters.Add("Direccion", cliente.Direccion);
            parameters.Add("Estatus", cliente.Estatus);

            parameters.Add("idCliente", dbType: DbType.Int32, direction: ParameterDirection.Output);
            parameters.Add("Success", dbType: DbType.Boolean, direction: ParameterDirection.Output);
            parameters.Add("Message", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

            await connection.ExecuteAsync("stp_Set_CreateCliente", parameters, commandType: CommandType.StoredProcedure);

            return parameters.Get<bool>("Success");
        }
    }
}
