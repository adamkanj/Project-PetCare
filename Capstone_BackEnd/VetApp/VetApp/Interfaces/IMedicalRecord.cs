using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IMedicalRecord
    {
        Task<MedicalRecordResource> GetMedicalRecordByIdAsync(int recordId);
        Task<IEnumerable<MedicalRecordResource>> GetAllMedicalRecordsAsync();
        Task<MedicalRecordResource> CreateMedicalRecordAsync(MedicalRecordResource medicalRecordResource);
        Task UpdateMedicalRecordAsync(int recordId, MedicalRecordResource medicalRecordResource);
        Task<bool> DeleteMedicalRecordAsync(int recordId);
        Task<IEnumerable<MedicalRecordResource>> GetAllMedicalRecordsByPetIdAsync(int petId);
         }
}