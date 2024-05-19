using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/medical-records")]
    [ApiController]
    public class MedicalRecordController : ControllerBase
    {
        private readonly IMedicalRecord _medicalRecordRepository;

        public MedicalRecordController(IMedicalRecord medicalRecordRepository)
        {
            _medicalRecordRepository = medicalRecordRepository;
        }

        [HttpGet("{recordId}")]
        public async Task<ActionResult<MedicalRecordResource>> GetMedicalRecordById(int recordId)
        {
            var record = await _medicalRecordRepository.GetMedicalRecordByIdAsync(recordId);
            if (record == null)
            {
                return NotFound();
            }

            return Ok(record);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<MedicalRecordResource>>> GetAllMedicalRecords()
        {
            var records = await _medicalRecordRepository.GetAllMedicalRecordsAsync();
            return Ok(records);
        }

        [HttpPost]
        public async Task<ActionResult<MedicalRecordResource>> CreateMedicalRecord(MedicalRecordResource medicalRecordResource)
        {
            var createdRecord = await _medicalRecordRepository.CreateMedicalRecordAsync(medicalRecordResource);
            return CreatedAtAction(nameof(GetMedicalRecordById), new { recordId = createdRecord.RecordId }, createdRecord);
        }

        [HttpPut("{recordId}")]
        public async Task<IActionResult> UpdateMedicalRecord(int recordId, MedicalRecordResource medicalRecordResource)
        {
            await _medicalRecordRepository.UpdateMedicalRecordAsync(recordId, medicalRecordResource);
            return Ok();
        }

        [HttpDelete("{recordId}")]
        public async Task<IActionResult> DeleteMedicalRecord(int recordId)
        {
            var result = await _medicalRecordRepository.DeleteMedicalRecordAsync(recordId);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }

        [HttpGet("pet/{petId}")]
        public async Task<IActionResult> GetAllMedicalRecordsByPetId(int petId)
        {
            var records = await _medicalRecordRepository.GetAllMedicalRecordsByPetIdAsync(petId);
            if (records == null || !records.Any())
            {
                return NotFound();
            }
            return Ok(records);
        }


    }
}