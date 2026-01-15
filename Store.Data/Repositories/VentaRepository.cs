using Dapper;
using Store.Entities;
using System.Data;
using static Store.Data.Context.Context;

namespace Store.Data.Repositories
{
    public class VentaRepository : IVentaRepository
    {
        private readonly DapperContext _context;
        public VentaRepository(DapperContext context) => _context = context;

        public async Task<bool> RegistrarVenta(Venta venta)
        {
            using var conn = _context.CreateConnection();
            conn.Open();
            using var trans = conn.BeginTransaction(); // Iniciamos transacción por seguridad

            try
            {
                var p = new DynamicParameters();
                p.Add("idCliente", venta.IdCliente);
                p.Add("Total", venta.Total);
                // Parámetro de salida para obtener el ID que genere la base de datos
                p.Add("NuevoIdCarrito", dbType: DbType.Int32, direction: ParameterDirection.Output);
                p.Add("Success", dbType: DbType.Boolean, direction: ParameterDirection.Output);
                p.Add("Message", dbType: DbType.String, size: 500, direction: ParameterDirection.Output);

                // 1. Ejecutamos el encabezado
                await conn.ExecuteAsync("stp_Set_RegistrarCompra", p, transaction: trans, commandType: CommandType.StoredProcedure);

                if (p.Get<bool>("Success"))
                {
                    int idGenerado = p.Get<int>("NuevoIdCarrito");

                    // 2. Recorremos los detalles y los guardamos
                    foreach (var det in venta.Detalles)
                    {
                        var pDet = new DynamicParameters();
                        pDet.Add("idCarrito", idGenerado);
                        pDet.Add("idArticulo", det.IdArticulo);
                        pDet.Add("cantidad", det.Cantidad);
                        pDet.Add("precio", det.PrecioUnitario);
                        pDet.Add("subtotal", det.Subtotal);

                        await conn.ExecuteAsync("stp_Set_RegistrarDetalleCompra", pDet, transaction: trans, commandType: CommandType.StoredProcedure);
                    }

                    trans.Commit(); // Si todo salió bien, guardamos todo en SQL
                    return true;
                }
                return false;
            }
            catch
            {
                trans.Rollback(); // Si algo falló, deshacemos para no dejar basura
                return false;
            }
        }
    }
}
