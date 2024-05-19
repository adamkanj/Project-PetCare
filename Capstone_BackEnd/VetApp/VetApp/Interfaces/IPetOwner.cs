
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IPetOwner
    {
        Task<PetOwnerResource> CreatePetOwnerAsync(PetOwnerResource petOwnerResource);
        Task<PetOwnerResource> GetPetOwnerByOwnerIdAsync(int ownerId);
        Task<IEnumerable<PetOwnerResource>> GetAllPetOwnersAsync();
        Task UpdatePetOwnerAsync(int ownerId, PetOwnerResource petOwnerResource);
        Task<bool> DeletePetOwnerAsync(int ownerId);
        Task<bool> UpdatePasswordAsync(int userId, string oldPassword, string newPassword);
    }
}
