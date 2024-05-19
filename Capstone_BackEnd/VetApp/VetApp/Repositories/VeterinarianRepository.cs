using AutoMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Models;
using VetApp.PasswordHashing;
using VetApp.Resources;

namespace VetApp.Repositories
{
    public class VeterinarianRepository : IVeterinarian
    {
        private readonly VetAppContext _context;
        private readonly IMapper _mapper;
        private readonly IPasswordHashingService _passwordHashingService;

        public VeterinarianRepository(VetAppContext context, IMapper mapper, IPasswordHashingService passwordHashingService)
        {
            _context = context;
            _mapper = mapper;
            _passwordHashingService = passwordHashingService;
        }

        public async Task<VeterinarianResource> CreateVeterinarianAsync(VeterinarianResource veterinarianResource)
        {
            // Hash the password
            var hashedPassword = _passwordHashingService.HashPassword(veterinarianResource.Password);

            // Create the User entity
            var user = new User
            {
                Username = veterinarianResource.Username,
                Password = hashedPassword,
                Email = veterinarianResource.Email,
                Fn = veterinarianResource.Fn,
                Ln = veterinarianResource.Ln,
                Dob = veterinarianResource.Dob,
                Gender = veterinarianResource.Gender,
                Role = "Veterinarian" // Set the role to "Veterinarian"
            };

            // Create the Veterinarian entity
            var veterinarian = new Veterinarian
            {
                Specialty = veterinarianResource.Specialty,
                WorkSchedule = veterinarianResource.WorkSchedule,
                Qualifications = veterinarianResource.Qualifications,
                YearsExperience = veterinarianResource.YearsExperience,
                Image = veterinarianResource.Image,
                User = user
            };

            _context.Veterinarians.Add(veterinarian);
            await _context.SaveChangesAsync();

            return _mapper.Map<VeterinarianResource>(veterinarian);
        }

        public async Task<VeterinarianResource> GetVeterinarianByVetIdAsync(int vetId)
        {
            var veterinarian = await _context.Veterinarians
                .Include(v => v.User)
                .FirstOrDefaultAsync(v => v.VetId == vetId);

            if (veterinarian == null)
            {
                return null;
            }

            var veterinarianResource = _mapper.Map<VeterinarianResource>(veterinarian);
            veterinarianResource.Username = veterinarian.User.Username;
            veterinarianResource.Email = veterinarian.User.Email;
            veterinarianResource.Fn = veterinarian.User.Fn;
            veterinarianResource.Ln = veterinarian.User.Ln;
            veterinarianResource.Dob = veterinarian.User.Dob;
            veterinarianResource.Gender = veterinarian.User.Gender;
            veterinarianResource.Role = veterinarian.User.Role;

            return veterinarianResource;
        }

        public async Task<IEnumerable<VeterinarianResource>> GetAllVeterinariansAsync()
        {
            var veterinarians = await _context.Veterinarians
                .Include(v => v.User)
                .ToListAsync();

            var veterinarianResources = veterinarians.Select(v =>
            {
                var veterinarianResource = _mapper.Map<VeterinarianResource>(v);
                veterinarianResource.Username = v.User.Username;
                veterinarianResource.Email = v.User.Email;
                veterinarianResource.Fn = v.User.Fn;
                veterinarianResource.Ln = v.User.Ln;
                veterinarianResource.Dob = v.User.Dob;
                veterinarianResource.Gender = v.User.Gender;
                veterinarianResource.Role = v.User.Role;

                return veterinarianResource;
            });

            return veterinarianResources;
        }

        public async Task UpdateVeterinarianAsync(int vetId, VeterinarianResource veterinarianResource)
        {
            try
            {
                // Retrieve the existing veterinarian entity from the database
                var veterinarian = await _context.Veterinarians
                    .Include(v => v.User) // Include the related User entity
                    .FirstOrDefaultAsync(v => v.VetId == vetId);

                // If the veterinarian entity doesn't exist, throw an exception
                if (veterinarian == null)
                {
                    throw new Exception($"Veterinarian with ID {vetId} not found");
                }

                // Update non-password properties of the veterinarian
                veterinarian.Specialty = veterinarianResource.Specialty;
                veterinarian.WorkSchedule = veterinarianResource.WorkSchedule;
                veterinarian.Qualifications = veterinarianResource.Qualifications;
                veterinarian.YearsExperience = veterinarianResource.YearsExperience;
                veterinarian.Image = veterinarianResource.Image;

                // Update non-password properties of the associated user
                if (veterinarian.User != null)
                {
                    veterinarian.User.Fn = veterinarianResource.Fn;
                    veterinarian.User.Ln = veterinarianResource.Ln;
                    veterinarian.User.Email = veterinarianResource.Email;
                    veterinarian.User.Dob = veterinarianResource.Dob;
                    veterinarian.User.Gender = veterinarianResource.Gender;
                    // Update other properties here...
                }
                else
                {
                    throw new Exception($"User for veterinarian with ID {vetId} is null");
                }

                // Save changes to the database
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                // Log the exception details
                Console.WriteLine($"Error updating veterinarian: {ex.Message}");
                throw; // Rethrow the exception to propagate it to the caller
            }
        }


        public async Task<bool> DeleteVeterinarianAsync(int vetId)
        {
            var veterinarian = await _context.Veterinarians
                .Include(v => v.User)
                .FirstOrDefaultAsync(v => v.VetId == vetId);

            if (veterinarian == null)
            {
                return false;
            }

            _context.Veterinarians.Remove(veterinarian);
            _context.Users.Remove(veterinarian.User); // Assuming a cascade delete is not enabled

            await _context.SaveChangesAsync();
            return true;
        }
    }
}
