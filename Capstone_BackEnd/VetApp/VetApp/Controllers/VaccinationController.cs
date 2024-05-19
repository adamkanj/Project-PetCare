using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VaccinationController : ControllerBase
    {
        private readonly IVaccination _vaccinationRepository;

        public VaccinationController(IVaccination vaccinationRepository)
        {
            _vaccinationRepository = vaccinationRepository;
        }

        [HttpGet("{vaccinationId}")]
        public async Task<ActionResult<VaccinationResource>> GetVaccinationById(int vaccinationId)
        {
            var vaccination = await _vaccinationRepository.GetVaccinationByIdAsync(vaccinationId);
            if (vaccination == null)
            {
                return NotFound();
            }

            return Ok(vaccination);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<VaccinationResource>>> GetAllVaccinations()
        {
            var vaccinations = await _vaccinationRepository.GetAllVaccinationsAsync();
            return Ok(vaccinations);
        }

        [HttpPost]
        public async Task<ActionResult<VaccinationResource>> CreateVaccination(VaccinationResource vaccinationResource)
        {
            var createdVaccination = await _vaccinationRepository.CreateVaccinationAsync(vaccinationResource);
            return CreatedAtAction(nameof(GetVaccinationById), new { vaccinationId = createdVaccination.VaccinationId }, createdVaccination);
        }

        [HttpPut("{vaccinationId}")]
        public async Task<IActionResult> UpdateVaccination(int vaccinationId, VaccinationResource vaccinationResource)
        {
            await _vaccinationRepository.UpdateVaccinationAsync(vaccinationId, vaccinationResource);
            return Ok();
        }

        [HttpDelete("{vaccinationId}")]
        public async Task<IActionResult> DeleteVaccination(int vaccinationId)
        {
            var result = await _vaccinationRepository.DeleteVaccinationAsync(vaccinationId);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }
        [HttpGet("pet/{petId}")]
        public async Task<ActionResult<IEnumerable<VaccinationResource>>> GetAllVaccinationByPetId(int petId)
        {
            try
            {
                var vaccinations = await _vaccinationRepository.GetAllVaccinationByPetId(petId);
                return Ok(vaccinations);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
