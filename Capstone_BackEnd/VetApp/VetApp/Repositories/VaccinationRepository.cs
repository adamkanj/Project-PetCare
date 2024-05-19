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
    public class VaccinationRepository : IVaccination
    {
        private readonly VetAppContext _context;

        public VaccinationRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<VaccinationResource> GetVaccinationByIdAsync(int vaccinationId)
        {
            var vaccination = await _context.Vaccinations.FindAsync(vaccinationId);
            return vaccination != null ? MapVaccinationToResource(vaccination) : null;
        }

        public async Task<IEnumerable<VaccinationResource>> GetAllVaccinationsAsync()
        {
            var vaccinations = await _context.Vaccinations.ToListAsync();
            return vaccinations.Select(v => MapVaccinationToResource(v));
        }

        public async Task<VaccinationResource> CreateVaccinationAsync(VaccinationResource vaccinationResource)
        {
            var vaccination = new Vaccination
            {
                PetId = vaccinationResource.PetId,
                VaccineName = vaccinationResource.VaccineName,
                Notes = vaccinationResource.Notes,
                DateAdministered = vaccinationResource.DateAdministered,
                NextDueDate = vaccinationResource.NextDueDate,
                Status = vaccinationResource.Status
            };

            _context.Vaccinations.Add(vaccination);
            await _context.SaveChangesAsync();

            return MapVaccinationToResource(vaccination);
        }

        public async Task UpdateVaccinationAsync(int vaccinationId, VaccinationResource vaccinationResource)
        {
            var vaccination = await _context.Vaccinations.FindAsync(vaccinationId);
            if (vaccination == null)
            {
                throw new Exception($"Vaccination with ID {vaccinationId} not found");
            }

            vaccination.PetId = vaccinationResource.PetId;
            vaccination.VaccineName = vaccinationResource.VaccineName;
            vaccination.Notes = vaccinationResource.Notes;
            vaccination.DateAdministered = vaccinationResource.DateAdministered;
            vaccination.NextDueDate = vaccinationResource.NextDueDate;
            vaccination.Status = vaccinationResource.Status;

            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteVaccinationAsync(int vaccinationId)
        {
            var vaccination = await _context.Vaccinations.FindAsync(vaccinationId);
            if (vaccination == null)
            {
                return false;
            }

            _context.Vaccinations.Remove(vaccination);
            await _context.SaveChangesAsync();
            return true;
        }

        private VaccinationResource MapVaccinationToResource(Vaccination vaccination)
        {
            return new VaccinationResource
            {
                VaccinationId = vaccination.VaccinationId,
                PetId = vaccination.PetId,
                VaccineName = vaccination.VaccineName,
                Notes = vaccination.Notes,
                DateAdministered = vaccination.DateAdministered,
                NextDueDate = vaccination.NextDueDate,
                Status = vaccination.Status
            };
        }
        public async Task<IEnumerable<VaccinationResource>> GetAllVaccinationByPetId(int petId)
        {
            var vaccinations = await _context.Vaccinations
                .Where(v => v.PetId == petId)
                .ToListAsync();

            // Convert each Vaccination entity to VaccinationResource
            var vaccinationResources = vaccinations.Select(v => new VaccinationResource
            {
                VaccinationId = v.VaccinationId,
                PetId = v.PetId,
                VaccineName = v.VaccineName,
                Notes = v.Notes,
                DateAdministered = v.DateAdministered,
                NextDueDate = v.NextDueDate,
                Status = v.Status
            }).ToList();

            return vaccinationResources;
        }

    }
}
