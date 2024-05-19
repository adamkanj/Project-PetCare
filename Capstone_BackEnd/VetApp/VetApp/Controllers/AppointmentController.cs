using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AppointmentController : ControllerBase
    {
        private readonly IAppointment _appointmentRepository;

        public AppointmentController(IAppointment appointmentRepository)
        {
            _appointmentRepository = appointmentRepository;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<AppointmentResource>>> GetAppointments()
        {
            var appointments = await _appointmentRepository.GetAllAppointmentsAsync();
            return Ok(appointments);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<AppointmentResource>> GetAppointmentById(int id)
        {
            var appointment = await _appointmentRepository.GetAppointmentByIdAsync(id);
            if (appointment == null)
            {
                return NotFound();
            }
            return Ok(appointment);
        }

        [HttpGet("vet/{vetId}")]
        public async Task<ActionResult<IEnumerable<AppointmentResource>>> GetAppointmentsByVetId(int vetId)
        {
            var appointments = await _appointmentRepository.GetAppointmentsByVetIdAsync(vetId);
            return Ok(appointments);
        }

        [HttpGet("owner/{ownerId}")]
        public async Task<ActionResult<IEnumerable<AppointmentResource>>> GetAppointmentsByOwnerId(int ownerId)
        {
            var appointments = await _appointmentRepository.GetAppointmentsByOwnerIdAsync(ownerId);
            return Ok(appointments);
        }

        [HttpPost]
        public async Task<ActionResult<AppointmentResource>> CreateAppointment(AppointmentResource appointmentResource)
        {
            try
            {
                bool created = await _appointmentRepository.CreateAppointmentAsync(appointmentResource);
                if (!created)
                {
                    return Conflict("Appointment slot is not available");
                }
                return CreatedAtAction(nameof(GetAppointmentById), new { id = appointmentResource.AppointmentId }, appointmentResource);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateAppointment(int id, AppointmentResource appointmentResource)
        {
            if (id != appointmentResource.AppointmentId)
            {
                return BadRequest("Appointment ID mismatch");
            }

            try
            {
                bool updated = await _appointmentRepository.UpdateAppointmentAsync(id, appointmentResource);
                if (!updated)
                {
                    return Conflict("Appointment slot is not available");
                }
                return NoContent();
            }
            catch (ArgumentException ex)
            {
                return NotFound(new { message = ex.Message });
            }
            catch (InvalidOperationException ex)
            {
                return Conflict(new { message = ex.Message });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteAppointment(int id)
        {
            try
            {
                await _appointmentRepository.DeleteAppointmentAsync(id);
                return Ok(); // Or return any other appropriate response
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred while deleting the appointment: {ex.Message}");
            }
        }


    }
}
