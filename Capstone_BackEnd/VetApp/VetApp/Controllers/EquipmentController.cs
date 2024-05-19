using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EquipmentController : ControllerBase
    {
        private readonly IEquipment _equipmentRepository;

        public EquipmentController(IEquipment equipmentRepository)
        {
            _equipmentRepository = equipmentRepository;
        }

        [HttpGet("{equipmentId}")]
        public async Task<ActionResult<EquipmentResource>> GetEquipmentById(int equipmentId)
        {
            var equipment = await _equipmentRepository.GetEquipmentByIdAsync(equipmentId);
            if (equipment == null)
            {
                return NotFound();
            }

            return Ok(equipment);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<EquipmentResource>>> GetAllEquipment()
        {
            var equipment = await _equipmentRepository.GetAllEquipmentAsync();
            return Ok(equipment);
        }

        [HttpPost]
        public async Task<ActionResult<EquipmentResource>> CreateEquipment(EquipmentResource equipmentResource)
        {
            var createdEquipment = await _equipmentRepository.CreateEquipmentAsync(equipmentResource);
            return CreatedAtAction(nameof(GetEquipmentById), new { equipmentId = createdEquipment.EquipmentId }, createdEquipment);
        }

        [HttpPut("{equipmentId}")]
        public async Task<IActionResult> UpdateEquipment(int equipmentId, EquipmentResource equipmentResource)
        {
            await _equipmentRepository.UpdateEquipmentAsync(equipmentId, equipmentResource);
            return Ok();
        }

        [HttpDelete("{equipmentId}")]
        public async Task<IActionResult> DeleteEquipment(int equipmentId)
        {
            var result = await _equipmentRepository.DeleteEquipmentAsync(equipmentId);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }
    }
}
