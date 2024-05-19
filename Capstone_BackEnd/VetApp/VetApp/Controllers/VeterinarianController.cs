using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VetApp.Interfaces;
using VetApp.Models;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VeterinarianController : ControllerBase
    {
        private readonly IVeterinarian _veterinarianRepository;
        private readonly VetAppContext _context;


        public VeterinarianController(IVeterinarian veterinarianRepository, VetAppContext context)
        {
            _veterinarianRepository = veterinarianRepository;
            _context = context;

        }

        [HttpPost]
        public async Task<ActionResult<VeterinarianResource>> CreateVeterinarian(VeterinarianResource veterinarianResource)
        {
            // Check if the email is already used
            var existingEmail = await _context.Users.AnyAsync(u => u.Email == veterinarianResource.Email);
            if (existingEmail)
            {
                return BadRequest("Email is already used.");
            }

            // Check if the username is already taken
            var existingUsername = await _context.Users.AnyAsync(u => u.Username == veterinarianResource.Username);
            if (existingUsername)
            {
                return BadRequest("Username is already taken.");
            }

            var createdVeterinarian = await _veterinarianRepository.CreateVeterinarianAsync(veterinarianResource);
            return CreatedAtAction(nameof(GetVeterinarianByVetId), new { vetId = createdVeterinarian.VetId }, createdVeterinarian);
        }

        [HttpGet("{vetId}")]
        public async Task<ActionResult<VeterinarianResource>> GetVeterinarianByVetId(int vetId)
        {
            var veterinarian = await _veterinarianRepository.GetVeterinarianByVetIdAsync(vetId);
            if (veterinarian == null)
                return NotFound();

            return Ok(veterinarian);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<VeterinarianResource>>> GetAllVeterinarians()
        {
            var veterinarians = await _veterinarianRepository.GetAllVeterinariansAsync();
            return Ok(veterinarians);
        }

        [HttpPut("{vetId}")]
        public async Task<IActionResult> UpdateVeterinarian(int vetId, VeterinarianResource veterinarianResource)
        {
            try
            {
                // Update the veterinarian
                await _veterinarianRepository.UpdateVeterinarianAsync(vetId, veterinarianResource);

                // Optionally, return an appropriate response
                return Ok();
            }
            catch (Exception ex)
            {
                // Log the exception details
                Console.WriteLine($"Error updating veterinarian: {ex.Message}");
                return StatusCode(500, "An error occurred while updating the veterinarian.");
            }
        }

        [HttpDelete("{vetId}")]
        public async Task<IActionResult> DeleteVeterinarian(int vetId)
        {
            var result = await _veterinarianRepository.DeleteVeterinarianAsync(vetId);
            if (!result)
                return NotFound();

            return NoContent();
        }

    }
}
