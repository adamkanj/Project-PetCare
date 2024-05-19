using AutoMapper;
using Microsoft.AspNetCore.Identity;
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
    public class PetOwnerRepository : IPetOwner
    {
        private readonly VetAppContext _context;
        private readonly IMapper _mapper;
        private readonly IPasswordHashingService _passwordHashingService;

        public PetOwnerRepository(VetAppContext context, IMapper mapper, IPasswordHashingService passwordHashingService)
        {
            _context = context;
            _mapper = mapper;
            _passwordHashingService = passwordHashingService;
        }

        public async Task<PetOwnerResource> CreatePetOwnerAsync(PetOwnerResource petOwnerResource)
        {

            // Hash the password
            var hashedPassword = _passwordHashingService.HashPassword(petOwnerResource.Password);

            // Create the User entity
            var user = new User
            {
                Username = petOwnerResource.Username,
                Password = hashedPassword,
                Email = petOwnerResource.Email,
                Fn = petOwnerResource.Fn,
                Ln = petOwnerResource.Ln,
                Dob = petOwnerResource.Dob,
                Gender = petOwnerResource.Gender,
                Role = "PetOwner" // Set the role to "PetOwner"
            };

            // Create the PetOwner entity
            var petOwner = new PetOwner
            {
                Address = petOwnerResource.Address,
                User = user
            };

            _context.PetOwners.Add(petOwner);
            await _context.SaveChangesAsync();

            return _mapper.Map<PetOwnerResource>(petOwner);
        }

        public async Task<PetOwnerResource> GetPetOwnerByOwnerIdAsync(int ownerId)
        {
            var petOwner = await _context.PetOwners
                .Include(p => p.User) // Include the related User entity
                .FirstOrDefaultAsync(p => p.OwnerId == ownerId);

            if (petOwner == null)
            {
                return null; // Or throw an exception if necessary
            }

            var petOwnerResource = _mapper.Map<PetOwnerResource>(petOwner);
            petOwnerResource.Username = petOwner.User.Username;
            petOwnerResource.Email = petOwner.User.Email;
            petOwnerResource.Fn = petOwner.User.Fn;
            petOwnerResource.Ln = petOwner.User.Ln;
            petOwnerResource.Dob = petOwner.User.Dob;
            petOwnerResource.Gender = petOwner.User.Gender;
            petOwnerResource.Role = petOwner.User.Role;

            return petOwnerResource;
        }

        public async Task<IEnumerable<PetOwnerResource>> GetAllPetOwnersAsync()
        {
            var petOwners = await _context.PetOwners
                .Include(p => p.User) // Include the related User entity
                .ToListAsync();

            var petOwnerResources = petOwners.Select(p =>
            {
                var petOwnerResource = _mapper.Map<PetOwnerResource>(p);
                petOwnerResource.Username = p.User.Username;
                petOwnerResource.Email = p.User.Email;
                petOwnerResource.Fn = p.User.Fn;
                petOwnerResource.Ln = p.User.Ln;
                petOwnerResource.Dob = p.User.Dob;
                petOwnerResource.Gender = p.User.Gender;
                petOwnerResource.Role = p.User.Role;

                return petOwnerResource;
            });

            return petOwnerResources;
        }

        public async Task UpdatePetOwnerAsync(int ownerId, PetOwnerResource petOwnerResource)
        {
            try
            {
                // Retrieve the existing pet owner entity from the database
                var petOwner = await _context.PetOwners
                    .Include(p => p.User) // Include the related User entity
                    .FirstOrDefaultAsync(p => p.OwnerId == ownerId);

                // If the pet owner entity doesn't exist, throw an exception
                if (petOwner == null)
                {
                    throw new Exception($"Pet owner with ID {ownerId} not found");
                }

                // Update non-password properties of the pet owner
                petOwner.Address = petOwnerResource.Address;

                // Update non-password properties of the associated user
                if (petOwner.User != null)
                {
                    petOwner.User.Fn = petOwnerResource.Fn;
                    petOwner.User.Ln = petOwnerResource.Ln;
                    // Update other properties here...
                }
                else
                {
                    throw new Exception($"User for pet owner with ID {ownerId} is null");
                }

                // Save changes to the database
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                // Log the exception details
                Console.WriteLine($"Error updating pet owner: {ex.Message}");
                throw; // Rethrow the exception to propagate it to the caller
            }
        }



        public async Task<bool> DeletePetOwnerAsync(int ownerId)
        {
            var petOwner = await _context.PetOwners
                .Include(p => p.User)
                .FirstOrDefaultAsync(p => p.OwnerId == ownerId);

            if (petOwner == null)
            {
                return false; // Or throw an exception if necessary
            }

            _context.PetOwners.Remove(petOwner);
            _context.Users.Remove(petOwner.User); // Assuming a cascade delete is not enabled

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> UpdatePasswordAsync(int ownerId, string oldPassword, string newPassword)
        {
            // Retrieve the existing pet owner entity from the database
            var petOwner = await _context.PetOwners.Include(p => p.User).FirstOrDefaultAsync(p => p.OwnerId == ownerId);

            // If the pet owner entity doesn't exist, return false
            if (petOwner == null)
            {
                return false;
            }

            // Verify if the old password matches the hashed password stored in the database
            if (!_passwordHashingService.VerifyHashedPassword(petOwner.User.Password, oldPassword))
            {
                return false;
            }

            // Hash the new password
            var hashedNewPassword = _passwordHashingService.HashPassword(newPassword);

            // Update the password in the database
            petOwner.User.Password = hashedNewPassword;

            // Save changes to the database
            await _context.SaveChangesAsync();

            return true;
        }


    }
}
