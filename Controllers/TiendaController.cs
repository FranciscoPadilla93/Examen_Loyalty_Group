using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Store.Business.Services;
using Store.Entities;

namespace Store.API.Controllers
{
    //[Authorize] 
    [Route("api/[controller]")]
    [ApiController]
    public class TiendaController : Controller
    {
        private readonly ITiendaService _service;
        public TiendaController(ITiendaService service) => _service = service;

        [HttpGet]
        public async Task<IActionResult> GetAll() => Ok(await _service.ListarTodas());

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var tienda = await _service.ObtenerPorId(id);
            if (tienda == null) return NotFound(new { message = "Tienda no encontrada" });
            return Ok(tienda);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Tienda tienda)
        {
            var result = await _service.NuevaTienda(tienda);
            if (result) return Ok(new { message = "Tienda creada con éxito" });
            return BadRequest(new { message = "No se pudo crear la tienda" });
        }

        [HttpPut]
        public async Task<IActionResult> Update([FromBody] Tienda tienda)
        {
            var result = await _service.EditarTienda(tienda);
            if (result) return Ok(new { message = "Tienda actualizada" });
            return BadRequest(new { message = "Error al actualizar" });
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _service.EliminarTienda(id);
            if (result) return Ok(new { message = "Tienda eliminada" });
            return BadRequest(new { message = "No se pudo eliminar" });
        }
    }
}
