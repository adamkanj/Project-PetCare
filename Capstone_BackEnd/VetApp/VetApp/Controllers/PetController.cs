using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PetController : ControllerBase
    {
        private readonly IPet _petRepository;

        public PetController(IPet petRepository)
        {
            _petRepository = petRepository;
        }

        [HttpGet("{petId}")]
        public async Task<ActionResult<PetResource>> GetPetById(int petId)
        {
            var pet = await _petRepository.GetPetByIdAsync(petId);
            if (pet == null)
            {
                return NotFound();
            }

            return Ok(pet);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<PetResource>>> GetAllPets()
        {
            var pets = await _petRepository.GetAllPetsAsync();
            return Ok(pets);
        }

        [HttpPost]
        public async Task<ActionResult<PetResource>> CreatePet(PetResource petResource)
        {
            var createdPet = await _petRepository.CreatePetAsync(petResource);
            return CreatedAtAction(nameof(GetPetById), new { petId = createdPet.PetId }, createdPet);
        }

        [HttpPut("{petId}")]
        public async Task<IActionResult> UpdatePet(int petId, PetResource petResource)
        {
            await _petRepository.UpdatePetAsync(petId, petResource);
            return Ok();
        }

        [HttpDelete("{petId}")]
        public async Task<IActionResult> DeletePet(int petId)
        {
            var result = await _petRepository.DeletePetAsync(petId);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }

        [HttpGet("details")]
        public async Task<ActionResult<List<PetDetails>>> GetAllPetDetails()
        {
            var petDetailsList = await _petRepository.GetAllPetDetailsAsync();

            if (petDetailsList == null || petDetailsList.Count == 0)
                return NotFound();

            return petDetailsList;
        }
        
        [HttpGet("by-owner/{ownerId}")]
        public async Task<IActionResult> GetPetsByOwnerId(int ownerId)
        {
            var pets = await _petRepository.GetPetsByOwnerId(ownerId);
            if (pets == null || !pets.Any())
            {
                return NotFound($"No pets found for owner with ID {ownerId}");
            }

            return Ok(pets);
        }

    }
}
