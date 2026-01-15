using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Store.Business.Services;
using Store.Entities;

namespace Store.API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class VentaController : ControllerBase
    {
        [Authorize]
        [Route("api/[controller]")]
        [ApiController]
        public class CarritoController : ControllerBase
        {
            private readonly IVentaService _ventaService;

            public CarritoController(IVentaService ventaService)
            {
                _ventaService = ventaService;
            }

            [HttpPost]
            public async Task<IActionResult> RegistrarCompra([FromBody] Venta venta)
            {
                if (venta == null || venta.Detalles == null || venta.Detalles.Count == 0)
                {
                    return BadRequest(new { message = "La venta no tiene productos o está vacía." });
                }

                try
                {
                    bool resultado = await _ventaService.RegistrarVenta(venta);

                    if (resultado)
                    {
                        return Ok(new { message = "¡Venta realizada con éxito!", success = true });
                    }
                    else
                    {
                        return BadRequest(new { message = "Error al procesar la venta en la base de datos.", success = false });
                    }
                }
                catch (Exception ex)
                {
                    return StatusCode(500, new { message = "Error interno: " + ex.Message });
                }
            }
        }
    }
}
