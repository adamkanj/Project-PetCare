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
    public class AppointmentRepository : IAppointment
    {
        private readonly VetAppContext _context;

        public AppointmentRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<AppointmentResource>> GetAllAppointmentsAsync()
        {
            // Retrieve appointments from the database and map them to AppointmentResource objects
            return _context.Appointments
                .Select(a => new AppointmentResource
                {
                    AppointmentId = a.AppointmentId,
                    OwnerId = a.OwnerId,
                    VetId = a.VetId,
                    PetId = a.PetId,
                    Description = a.Description,
                    AppointmentDate = a.AppointmentDate,
                    Category = a.Category,
                    Status = a.Status
                })
                .ToList();
        }

        public async Task<AppointmentResource> GetAppointmentByIdAsync(int id)
        {
            // Retrieve an appointment by ID from the database and map it to an AppointmentResource object
            var appointment = await _context.Appointments.FindAsync(id);
            if (appointment == null)
            {
                return null;
            }

            return new AppointmentResource
            {
                AppointmentId = appointment.AppointmentId,
                OwnerId = appointment.OwnerId,
                VetId = appointment.VetId,
                PetId = appointment.PetId,
                Description = appointment.Description,
                AppointmentDate = appointment.AppointmentDate,
                Category = appointment.Category,
                Status = appointment.Status
            };
        }

        public async Task<IEnumerable<AppointmentResource>> GetAppointmentsByVetIdAsync(int vetId)
        {
            // Retrieve appointments by veterinarian ID from the database and map them to AppointmentResource objects
            return _context.Appointments
                .Where(a => a.VetId == vetId)
                .Select(a => new AppointmentResource
                {
                    AppointmentId = a.AppointmentId,
                    OwnerId = a.OwnerId,
                    VetId = a.VetId,
                    PetId = a.PetId,
                    Description = a.Description,
                    AppointmentDate = a.AppointmentDate,
                    Category = a.Category,
                    Status = a.Status
                })
                .ToList();
        }

        public async Task<IEnumerable<AppointmentResource>> GetAppointmentsByOwnerIdAsync(int ownerId)
        {
            // Retrieve appointments by owner ID from the database and map them to AppointmentResource objects
            return _context.Appointments
                .Where(a => a.OwnerId == ownerId)
                .Select(a => new AppointmentResource
                {
                    AppointmentId = a.AppointmentId,
                    OwnerId = a.OwnerId,
                    VetId = a.VetId,
                    PetId = a.PetId,
                    Description = a.Description,
                    AppointmentDate = a.AppointmentDate,
                    Category = a.Category,
                    Status = a.Status
                })
                .ToList();
        }

        public async Task<IEnumerable<AppointmentResource>> GetAvailableAppointmentsAsync(int vetId, DateTime startDate, DateTime endDate)
        {
            var vet = _context.Veterinarians.FirstOrDefault(v => v.VetId == vetId);
            if (vet == null)
            {
                throw new ArgumentException("Invalid veterinarian ID");
            }

            List<AppointmentResource> availableAppointments = new List<AppointmentResource>();

            // Get working days and time range for the veterinarian
            List<string> workingDays = GetWorkingDays(vet.WorkSchedule);
            string timeRange = GetTimeRange(vet.WorkSchedule);

            // Generate available appointments within the specified date range
            DateTime currentDate = startDate.Date;
            while (currentDate <= endDate)
            {
                string currentDay = currentDate.ToString("ddd").ToUpper(); // Get day abbreviation (e.g., MON, TUE, WED)
                if (workingDays.Contains(currentDay))
                {
                    DateTime startTime = DateTime.ParseExact(currentDate.ToString("yyyy-MM-dd") + " " + timeRange.Split('-')[0], "yyyy-MM-dd HH:mm", null);
                    DateTime endTime = DateTime.ParseExact(currentDate.ToString("yyyy-MM-dd") + " " + timeRange.Split('-')[1], "yyyy-MM-dd HH:mm", null);

                    while (startTime < endTime)
                    {
                        // Check if the appointment slot is available
                        if (await IsAppointmentAvailableAsync(vetId, startTime))
                        {
                            availableAppointments.Add(new AppointmentResource
                            {
                                VetId = vetId,
                                AppointmentDate = startTime
                            });
                        }

                        // Move to the next appointment slot (30 minutes later)
                        startTime = startTime.AddMinutes(30);
                    }
                }

                // Move to the next day
                currentDate = currentDate.AddDays(1);
            }

            return availableAppointments;
        }

        public async Task<bool> IsAppointmentAvailableAsync(int vetId, DateTime appointmentDate)
        {
            // Check if the appointment slot is available based on existing appointments
            return !_context.Appointments.Any(a => a.VetId == vetId && a.AppointmentDate == appointmentDate);
        }

        private List<string> GetWorkingDays(string workSchedule)
        {
            List<string> workingDays = new List<string>();

            // Extract working days from the schedule string
            string days = workSchedule.Substring(0, workSchedule.IndexOf(';'));
            foreach (char day in days)
            {
                workingDays.Add(day.ToString());
            }

            return workingDays;
        }

        private string GetTimeRange(string workSchedule)
        {
            // Extract time range from the schedule string
            int semicolonIndex = workSchedule.IndexOf(';');
            string timeRange = workSchedule.Substring(semicolonIndex + 1);
            return timeRange;
        }

        public async Task<bool> CreateAppointmentAsync(AppointmentResource appointmentResource)
        {
            // Check if the appointment date is within the veterinarian's work schedule
            var vet = _context.Veterinarians.FirstOrDefault(v => v.VetId == appointmentResource.VetId);
            if (vet == null)
            {
                throw new ArgumentException("Invalid veterinarian ID");
            }

            List<string> workingDays = GetWorkingDays(vet.WorkSchedule);
            string timeRange = GetTimeRange(vet.WorkSchedule);

            string appointmentDayAbbreviation = GetDayAbbreviation(appointmentResource.AppointmentDate.ToString("ddd").ToUpper()); // Get day abbreviation (e.g., MON, TUE, WED)
            
            if (!workingDays.Contains(appointmentDayAbbreviation))
            {
                throw new InvalidOperationException("Appointment date is not within veterinarian's work schedule"+ appointmentDayAbbreviation);
            }

            if (!IsAppointmentTimeWithinRange(timeRange, appointmentResource.AppointmentDate))
            {
                throw new InvalidOperationException("Appointment time is not within veterinarian's working hours");
            }

            DateTime startTime = appointmentResource.AppointmentDate;
            DateTime endTime = appointmentResource.AppointmentDate.AddMinutes(30);

            // Check if the appointment slot is available
            if (!_context.Appointments.Any(a => a.VetId == appointmentResource.VetId &&
                                                 a.AppointmentDate >= startTime && a.AppointmentDate < endTime))
            {
                // Create the appointment
                _context.Appointments.Add(new Appointment
                {
                    VetId = appointmentResource.VetId,
                    OwnerId = appointmentResource.OwnerId,
                    PetId = appointmentResource.PetId,
                    Description = appointmentResource.Description,
                    AppointmentDate = startTime,
                    Category = appointmentResource.Category,
                    Status = appointmentResource.Status
                });



                await _context.SaveChangesAsync();
                return true; // Appointment created successfully
            }

            throw new InvalidOperationException("Appointment slot is not available");
        }

        public string GetDayAbbreviation(string dayName)
        {
            switch (dayName.ToUpper())
            {
                case "MON":
                    return "M";
                case "TUE":
                    return "T";
                case "WED":
                    return "W";
                case "THU":
                    return "R";
                case "FRI":
                    return "F";
                default:
                    throw new ArgumentException("Invalid day name");
            }
        }


        public async Task<bool> UpdateAppointmentAsync(int appointmentId, AppointmentResource appointmentResource)
        {
            try
            {
                // Check if the appointment exists
                var existingAppointment = await _context.Appointments.FindAsync(appointmentId);
                if (existingAppointment == null)
                {
                    throw new ArgumentException("Appointment not found");
                }

                // Check if the appointment date is within the veterinarian's work schedule
                var vet = _context.Veterinarians.FirstOrDefault(v => v.VetId == appointmentResource.VetId);
                if (vet == null)
                {
                    throw new ArgumentException("Invalid veterinarian ID");
                }

                List<string> workingDays = GetWorkingDays(vet.WorkSchedule);
                string timeRange = GetTimeRange(vet.WorkSchedule);

                string appointmentDay = GetDayAbbreviation(appointmentResource.AppointmentDate.ToString("ddd").ToUpper()); // Get day abbreviation (e.g., MON, TUE, WED)
                if (!workingDays.Contains(appointmentDay))
                {
                    throw new InvalidOperationException("Appointment date is not within veterinarian's work schedule");
                }

                // Check if the appointment time falls within the veterinarian's working hours
                if (!IsAppointmentTimeWithinRange(timeRange, appointmentResource.AppointmentDate))
                {
                    throw new InvalidOperationException("Appointment time is not within veterinarian's working hours");
                }
                DateTime startTime = appointmentResource.AppointmentDate;
                DateTime endTime = appointmentResource.AppointmentDate.AddMinutes(30);
                // Check if the appointment slot is available (excluding the current appointment)
                if (!_context.Appointments.Any(a => a.VetId == appointmentResource.VetId &&
                                                     a.AppointmentDate >= startTime && a.AppointmentDate < endTime &&
                                                     a.AppointmentId != appointmentId))
                {
                    // Update the appointment
                    existingAppointment.OwnerId = appointmentResource.OwnerId;
                    existingAppointment.VetId = appointmentResource.VetId;
                    existingAppointment.PetId = appointmentResource.PetId;
                    existingAppointment.Description = appointmentResource.Description;
                    existingAppointment.AppointmentDate = appointmentResource.AppointmentDate;
                    existingAppointment.Category = appointmentResource.Category;
                    existingAppointment.Status = appointmentResource.Status;

                    await _context.SaveChangesAsync();
                    return true; // Appointment updated successfully
                }

                throw new InvalidOperationException("Appointment slot is not available");
            }
            catch (Exception ex)
            {
                // Log the exception
                Console.WriteLine($"An error occurred: {ex.Message}");
                // Propagate the exception to the calling code
                throw;
            }
        }



        public bool IsAppointmentTimeWithinRange(string timeRange, DateTime appointmentTime)
        {
            // Split the time range string into start and end times
            string[] times = timeRange.Split('-');
            if (times.Length != 2)
            {
                throw new ArgumentException("Invalid time range format");
            }

            // Parse start and end times
            if (!TimeSpan.TryParse(times[0], out TimeSpan startTime) || !TimeSpan.TryParse(times[1], out TimeSpan endTime))
            {
                throw new ArgumentException("Invalid time range format");
            }

            // Convert appointment time to TimeSpan
            TimeSpan appointmentStartTime = appointmentTime.TimeOfDay;
            TimeSpan appointmentEndTime = appointmentStartTime.Add(TimeSpan.FromMinutes(30));

            // Check if appointment time falls within the range
            return appointmentStartTime >= startTime && appointmentEndTime <= endTime;
        }


        public async Task DeleteAppointmentAsync(int appointmentId)
        {
            var appointment = await _context.Appointments.FindAsync(appointmentId);
            if (appointment != null)
            {
                _context.Appointments.Remove(appointment);
                await _context.SaveChangesAsync();
            }
            else
            {
                throw new ArgumentException("Appointment not found");
            }
        }

        

    }
}
