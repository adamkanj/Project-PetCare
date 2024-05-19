using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IVeterinarian
    {
        Task<VeterinarianResource> CreateVeterinarianAsync(VeterinarianResource veterinarianResource);
        Task<VeterinarianResource> GetVeterinarianByVetIdAsync(int vetId);
        Task<IEnumerable<VeterinarianResource>> GetAllVeterinariansAsync();
        Task UpdateVeterinarianAsync(int vetId, VeterinarianResource veterinarianResource);
        Task<bool> DeleteVeterinarianAsync(int vetId);
    }
}
