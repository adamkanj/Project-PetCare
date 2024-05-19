using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IVaccination
    {
        Task<VaccinationResource> GetVaccinationByIdAsync(int vaccinationId);
        Task<IEnumerable<VaccinationResource>> GetAllVaccinationsAsync();
        Task<VaccinationResource> CreateVaccinationAsync(VaccinationResource vaccinationResource);
        Task UpdateVaccinationAsync(int vaccinationId, VaccinationResource vaccinationResource);
        Task<bool> DeleteVaccinationAsync(int vaccinationId);
        Task<IEnumerable<VaccinationResource>> GetAllVaccinationByPetId(int petId);

    }
}
