using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Store.Business.Services;
using Store.Entities;

namespace Store.API.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ArticuloController : Controller
    {
        private readonly IArticuloService _service;
        public ArticuloController(IArticuloService service) => _service = service;

        [HttpGet]
        public async Task<IActionResult> GetAll() => Ok(await _service.ListarTodo());

        [HttpGet("tienda/{idTienda}")]
        public async Task<IActionResult> GetByTienda(int idTienda)
            => Ok(await _service.ListarPorTienda(idTienda));

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Articulo art)
        {
            var result = await _service.NuevoArticulo(art);
            if (result) return Ok(new { message = "Artículo agregado" });
            return BadRequest(new { message = "Datos inválidos" });
        }

        [HttpPut]
        public async Task<IActionResult> Update([FromBody] Articulo art)
        {
            var result = await _service.EditarArticulo(art);
            if (result) return Ok(new { message = "Artículo actualizado" });
            return BadRequest();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var result = await _service.EliminarArticulo(id);
            if (result) return Ok(new { message = "Artículo eliminado" });
            return BadRequest();
        }
    }
}
