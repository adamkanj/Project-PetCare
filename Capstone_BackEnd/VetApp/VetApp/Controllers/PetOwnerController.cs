using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Models;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PetOwnerController : ControllerBase
    {
        private readonly IPetOwner _petOwnerRepository;
        private readonly VetAppContext _context;

        public PetOwnerController(IPetOwner petOwnerRepository, VetAppContext context)
        {
            _petOwnerRepository = petOwnerRepository;
            _context = context;

        }

        [HttpPost]
        public async Task<ActionResult<PetOwnerResource>> CreatePetOwner(PetOwnerResource petOwnerResource)
        {
            // Check if the email is already used
            var existingEmail = await _context.Users.AnyAsync(u => u.Email == petOwnerResource.Email);
            if (existingEmail)
            {
                return BadRequest("Email is already used.");
            }

            // Check if the username is already taken
            var existingUsername = await _context.Users.AnyAsync(u => u.Username == petOwnerResource.Username);
            if (existingUsername)
            {
                return BadRequest("Username is already taken.");
            }


            var createdPetOwner = await _petOwnerRepository.CreatePetOwnerAsync(petOwnerResource);
            return CreatedAtAction(nameof(GetPetOwnerByOwnerId), new { ownerId = createdPetOwner.OwnerId }, createdPetOwner);
        }

        [HttpGet("{ownerId}")]
        public async Task<ActionResult<PetOwnerResource>> GetPetOwnerByOwnerId(int ownerId)
        {
            var petOwner = await _petOwnerRepository.GetPetOwnerByOwnerIdAsync(ownerId);
            if (petOwner == null)
                return NotFound();

            return Ok(petOwner);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<PetOwnerResource>>> GetAllPetOwners()
        {
            var petOwners = await _petOwnerRepository.GetAllPetOwnersAsync();
            return Ok(petOwners);
        }

        [HttpPut("{ownerId}")]
        public async Task<IActionResult> UpdatePetOwner(int ownerId, PetOwnerResource petOwnerResource)
        {
            // Update the pet owner
            await _petOwnerRepository.UpdatePetOwnerAsync(ownerId, petOwnerResource);

            // Optionally, return an appropriate response
            return Ok();
        }

        [HttpDelete("{ownerId}")]
        public async Task<IActionResult> DeletePetOwner(int ownerId)
        {
            var result = await _petOwnerRepository.DeletePetOwnerAsync(ownerId);
            if (!result)
                return NotFound();

            return NoContent();
        }

        [HttpGet("owner/{petId}")]
        public async Task<ActionResult<int>> GetPetOwnerId(int petId)
        {
            var pet = await _context.Pets.FindAsync(petId);

            if (pet == null)
            {
                return NotFound();
            }

            return pet.OwnerId;
        }
    }
}
