using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Store.Business.Services;
using Store.Entities;

namespace Store.API.Controllers
{
    //[Authorize]
    [AllowAnonymous]
    [Route("api/[controller]")]
    [ApiController]
    public class CarritoController : ControllerBase
    {
        private readonly IVentaService _ventaService;
        private readonly ICarritoService _carritoService;

        public CarritoController(IVentaService ventaService, ICarritoService carritoService)
        {
            _ventaService = ventaService;
            _carritoService = carritoService;
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Venta venta)
        {
            var resultado = await _ventaService.RegistrarVenta(venta);

            if (resultado) return Ok(new { message = "Venta procesada con éxito" });
            return BadRequest(new { message = "No se pudo registrar la venta" });
        }

        [HttpGet("GetHistorial/{idCliente}")]
        public async Task<IActionResult> GetHistorial(int idCliente)
        {
            try
            {
                var historial = await _carritoService.GetHistorialByCliente(idCliente);

                if (historial == null) return NotFound("No se encontraron compras.");

                return Ok(historial);
            }
            catch (Exception ex)
            {
                return BadRequest(new { error = ex.Message });
            }
        }
    }
}
