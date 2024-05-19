using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using VetApp.Interfaces;
using VetApp.Models;
using VetApp.PasswordHashing;
using VetApp.Repositories;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthenticationController : ControllerBase
    {
        private readonly VetAppContext _context;
        private readonly IPasswordHashingService _passwordHashingService;
        private readonly IAuthentication _authenticationRepository;

        public AuthenticationController(VetAppContext context, IPasswordHashingService passwordHashingService, IAuthentication authenticationRepository)
        {
            _context = context;
            _passwordHashingService = passwordHashingService;
            _authenticationRepository = authenticationRepository;

        }

        [HttpPost("login")]
        public async Task<ActionResult<string[]>> Login([FromBody] LoginDto loginDto)
        {
            if (string.IsNullOrEmpty(loginDto.UsernameOrEmail) || string.IsNullOrEmpty(loginDto.Password))
            {
                return Unauthorized("Missing username/email or password.");
            }

            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Username == loginDto.UsernameOrEmail || u.Email == loginDto.UsernameOrEmail);

            if (user == null)
            {
                return Unauthorized("User not found.");
            }

            bool isPasswordValid = _passwordHashingService.VerifyHashedPassword(user.Password, loginDto.Password);
            if (!isPasswordValid)
            {
                return Unauthorized("Invalid credentials.");
            }

            if (user.Role == "Admin")
            {
                return new string[] { "Admin", "1" };
            }
            else if (user.Role == "Veterinarian")
            {
                var vet = await _context.Veterinarians.FirstOrDefaultAsync(v => v.UserId == user.UserId);
                if (vet != null)
                {
                    return new string[] { "Veterinarian", vet.VetId.ToString() };
                }
            }
            else if (user.Role == "PetOwner")
            {
                var owner = await _context.PetOwners.FirstOrDefaultAsync(v => v.UserId == user.UserId);
                if (owner != null)
                {
                    return new string[] { "PetOwner", owner.OwnerId.ToString() };
                }
            }

            return BadRequest("Invalid role.");
        }


        [HttpPost("changePassword")]
        public async Task<ActionResult<bool>> ChangePassword(string usernameOrEmail, string currentPassword, string newPassword)
        {
            if (string.IsNullOrEmpty(usernameOrEmail) || string.IsNullOrEmpty(currentPassword) || string.IsNullOrEmpty(newPassword))
            {
                return BadRequest("All fields must be provided.");
            }

            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Username == usernameOrEmail || u.Email == usernameOrEmail);

            if (user == null)
            {
                return NotFound("User not found.");
            }

            // Check if the current password is correct
            bool isCurrentPasswordValid = _passwordHashingService.VerifyHashedPassword(user.Password, currentPassword);

            if (!isCurrentPasswordValid)
            {
                return Unauthorized("Current password is incorrect.");
            }

            // Hash the new password and update the user
            user.Password = _passwordHashingService.HashPassword(newPassword);
            _context.Users.Update(user);
            await _context.SaveChangesAsync();

            return Ok(true);
        }


        [HttpPost("signup")]
        public async Task<IActionResult> InitiateSignUp([FromBody] Usersignup usersignup)
        {
            if (usersignup == null)
            {
                return BadRequest("Invalid registration request.");
            }

            var registrationKey = await _authenticationRepository.InitiateSignUpAsync(usersignup);

            return Ok(new { RegistrationKey = registrationKey });
        }

        [HttpPost("verify")]
        public async Task<IActionResult> VerifyAndCreatePetOwner([FromBody] VerifyPetOwnerResource verifyPetOwnerResource)
        {
            if (verifyPetOwnerResource == null)
            {
                return BadRequest("Invalid verification request.");
            }

            var result = await _authenticationRepository.VerifyAndCreatePetOwnerAsync(
                verifyPetOwnerResource.RegistrationKey,
                verifyPetOwnerResource.VerificationCode
            );

            if (result.Result is BadRequestObjectResult)
            {
                return result.Result;
            }

            return Ok(result.Value);
        }
    }
}
public class VerifyPetOwnerResource
{
    public string RegistrationKey { get; set; }
    public string VerificationCode { get; set; }
}
public class LoginDto
    {
        public string UsernameOrEmail { get; set; }
        public string Password { get; set; }
    }


