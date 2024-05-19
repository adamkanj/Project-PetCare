using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Models;
using VetApp.Resources;

namespace VetApp.Repositories
{
    public class PetRepository : IPet
    {
        private readonly VetAppContext _context;

        public PetRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<PetResource> GetPetByIdAsync(int petId)
        {
            var pet = await _context.Pets.FindAsync(petId);
            return pet != null ? MapPetToResource(pet) : null;
        }

        public async Task<IEnumerable<PetResource>> GetAllPetsAsync()
        {
            var pets = await _context.Pets.ToListAsync();
            return pets.Select(p => MapPetToResource(p));
        }

        public async Task<PetResource> CreatePetAsync(PetResource petResource)
        {
            var pet = new Pet
            {
                OwnerId = petResource.OwnerId,
                Name = petResource.Name,
                Species = petResource.Species,
                Breed = petResource.Breed,
                Gender = petResource.Gender,
                Dob = petResource.Dob,
                Image = petResource.Image
            };

            _context.Pets.Add(pet);
            await _context.SaveChangesAsync();

            return MapPetToResource(pet);
        }

        public async Task UpdatePetAsync(int petId, PetResource petResource)
        {
            var pet = await _context.Pets.FindAsync(petId);
            if (pet == null)
            {
                throw new Exception($"Pet with ID {petId} not found");
            }

            pet.OwnerId = petResource.OwnerId;
            pet.Name = petResource.Name;
            pet.Species = petResource.Species;
            pet.Breed = petResource.Breed;
            pet.Gender = petResource.Gender;
            pet.Dob = petResource.Dob;
            pet.Image = petResource.Image;

            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeletePetAsync(int petId)
        {
            var pet = await _context.Pets.FindAsync(petId);
            if (pet == null)
            {
                return false;
            }

            _context.Pets.Remove(pet);
            await _context.SaveChangesAsync();
            return true;
        }

        private PetResource MapPetToResource(Pet pet)
        {
            return new PetResource
            {
                PetId = pet.PetId,
                OwnerId = pet.OwnerId,
                Name = pet.Name,
                Species = pet.Species,
                Breed = pet.Breed,
                Gender = pet.Gender,
                Dob = pet.Dob,
                Image = pet.Image
            };
        }
        public async Task<List<PetDetails>> GetAllPetDetailsAsync()
        {
            var petDetailsList = await _context.Pets
                .Select(pet => new PetDetails
                {
                    Id = pet.PetId,
                    Name = pet.Name,
                    Breed = pet.Breed,
                    Image = pet.Image != null ? pet.Image : new byte[0], // Handle null image
                    DOB = pet.Dob, // Format DOB as required
                    OwnerName = pet.OwnerId != null ? // Check if OwnerId is not null
                        (_context.PetOwners.Where(owner => owner.OwnerId == pet.OwnerId)
                                            .Select(owner => owner.User.Fn + " " + owner.User.Ln)
                                            .FirstOrDefault()) :
                        null
                })
                .ToListAsync();

            return petDetailsList;
        }
        public async Task<IEnumerable<PetResource>> GetPetsByOwnerId(int ownerId)
        {
            // Retrieve and map pets with a specific OwnerId asynchronously
            return await _context.Pets
                .Where(p => p.OwnerId == ownerId)
                .Select(p => new PetResource
                {
                    PetId = p.PetId,
                    OwnerId = p.OwnerId,
                    Name = p.Name,
                    Species = p.Species,
                    Breed = p.Breed,
                    Gender = p.Gender,
                    Dob = p.Dob,
                    Image = p.Image
                })
                .ToListAsync();
        }

    }
}
