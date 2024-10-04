using EnviosWebApi.Models;
using EnviosWebApi.Repositories;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace EnviosWebApi.Controllers
{


    [Route("api/[controller]")]
    [ApiController]
    public class EnviosController : ControllerBase
    { 
        IEnviosRepository _enviosRepository;

        public EnviosController(IEnviosRepository enviosRepository)
        {
            _enviosRepository = enviosRepository;
        }






        // GET: api/<EnviosController>
        [HttpGet]
        public IActionResult GetByDates(DateTime? fechaInicio, DateTime? fechaFin)
        {
            var envios = _enviosRepository.GetByDates(fechaInicio, fechaFin);

            if (envios == null || !envios.Any())
            {
                return NotFound("No se encontraron envios que coincidan con los criterios.");
            }

            return Ok(envios);
        }


        // POST api/<EnviosController>
        [HttpPost]
        public IActionResult Post([FromBody] TEnvio envio)
        {
            try
            {
                if (IsValid(envio))
                {
                    if (_enviosRepository.Create(envio)) ;
                    {
                        return Ok("Envio creado con exito");
                    }
                }
                else
                {
                    return BadRequest("Debe completar todos los campos");
                }
            }
            catch (Exception)
            {
                return StatusCode(500, "Ha ocurrido un error interno");
            }
        }


        // DELETE api/<EnviosController>/5
        [HttpDelete("{id}")]
        public IActionResult Delete(int id)
        {
            {
                try
                {
                    var envioDeleted = _enviosRepository.Delete(id);
                    if (envioDeleted)
                    {
                        return Ok("Envio eliminado correctamente");
                    }
                    else
                    {
                        return NotFound($"No existe un envio con el id: [{id}]");
                    }
                }
                catch (Exception)
                {
                    return StatusCode(500, "Ha ocurrido un error interno");
                }
            }
        }

        private bool IsValid(TEnvio envio)
        {
            return !string.IsNullOrEmpty(envio.Direccion) && !string.IsNullOrEmpty(envio.DniCliente) && !string.IsNullOrEmpty(envio.Estado) && envio.IdEmpresa != 0;
        }
    }
}
