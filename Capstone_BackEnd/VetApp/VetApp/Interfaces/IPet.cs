using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IPet
    {
        Task<PetResource> GetPetByIdAsync(int petId);
        Task<IEnumerable<PetResource>> GetAllPetsAsync();
        Task<PetResource> CreatePetAsync(PetResource petResource);
        Task UpdatePetAsync(int petId, PetResource petResource);
        Task<bool> DeletePetAsync(int petId);
        Task<List<PetDetails>> GetAllPetDetailsAsync();
        Task<IEnumerable<Resources.PetResource>> GetPetsByOwnerId(int ownerId);


    }
}
