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
    public class MedicalRecordRepository : IMedicalRecord
    {
        private readonly VetAppContext _context;

        public MedicalRecordRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<MedicalRecordResource> GetMedicalRecordByIdAsync(int recordId)
        {
            var record = await _context.MedicalRecords.FindAsync(recordId);
            return record != null ? MapMedicalRecordToResource(record) : null;
        }

        public async Task<IEnumerable<MedicalRecordResource>> GetAllMedicalRecordsAsync()
        {
            var records = await _context.MedicalRecords.ToListAsync();
            return records.Select(r => MapMedicalRecordToResource(r));
        }

        public async Task<MedicalRecordResource> CreateMedicalRecordAsync(MedicalRecordResource medicalRecordResource)
        {
            var record = new MedicalRecord
            {
                PetId = medicalRecordResource.PetId,
                Description = medicalRecordResource.Description,
                Service = medicalRecordResource.Service,
                TestResults = medicalRecordResource.TestResults,
                Date = medicalRecordResource.Date,
                Status = medicalRecordResource.Status
            };

            _context.MedicalRecords.Add(record);
            await _context.SaveChangesAsync();

            return MapMedicalRecordToResource(record);
        }

        public async Task UpdateMedicalRecordAsync(int recordId, MedicalRecordResource medicalRecordResource)
        {
            var record = await _context.MedicalRecords.FindAsync(recordId);
            if (record == null)
            {
                throw new Exception($"Medical record with ID {recordId} not found");
            }

            record.PetId = medicalRecordResource.PetId;
            record.Description = medicalRecordResource.Description;
            record.Service = medicalRecordResource.Service;
            record.TestResults = medicalRecordResource.TestResults;
            record.Date = medicalRecordResource.Date;
            record.Status = medicalRecordResource.Status;

            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteMedicalRecordAsync(int recordId)
        {
            var record = await _context.MedicalRecords.FindAsync(recordId);
            if (record == null)
            {
                return false;
            }

            _context.MedicalRecords.Remove(record);
            await _context.SaveChangesAsync();
            return true;
        }

        private MedicalRecordResource MapMedicalRecordToResource(MedicalRecord record)
        {
            return new MedicalRecordResource
            {
                RecordId = record.RecordId,
                PetId = record.PetId,
                Description = record.Description,
                Service = record.Service,
                TestResults = record.TestResults,
                Date = record.Date,
                Status = record.Status
            };
        }
        public async Task<IEnumerable<MedicalRecordResource>> GetAllMedicalRecordsByPetIdAsync(int petId)
        {
            var records = await _context.MedicalRecords.Where(r => r.PetId == petId).ToListAsync();
            return records.Select(r => MapMedicalRecordToResource(r));
        }


    }
}