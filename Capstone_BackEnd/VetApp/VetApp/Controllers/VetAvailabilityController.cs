using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using VetApp.Models;

namespace VetApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AvailabilityController : ControllerBase
    {
        private readonly VetAppContext _context;

        public AvailabilityController(VetAppContext context)
        {
            _context = context;
        }

        [HttpGet("GetAvailableSlots/{vetId}/{date}")]
        public async Task<IActionResult> GetAvailableSlots(int vetId, DateTime date)
        {
            date = date.Date; // Focus on the date part only
            var vet = await _context.Veterinarians.Include(v => v.User).FirstOrDefaultAsync(v => v.VetId == vetId);

            if (vet == null)
            {
                return NotFound($"Veterinarian with ID {vetId} not found.");
            }

            var availableSlots = new AvailableSlotResource
            {
                VetId = vet.VetId,
                VetName = $"{vet.User.Fn} {vet.User.Ln}",
                AvailableTimes = new List<DateTime>()
            };

            Console.WriteLine($"Requested date: {date:yyyy-MM-dd}, Vet: {vetId} ({vet.User.Fn} {vet.User.Ln})");

            // Use GetWorkingDays and GetTimeRange to determine vet's availability
            List<string> workingDays = GetWorkingDays(vet.WorkSchedule);
            string timeRange = GetTimeRange(vet.WorkSchedule);

            string dayOfWeekAbbr = GetDayAbbreviation(date.ToString("ddd").ToUpper());

            if (!workingDays.Contains(dayOfWeekAbbr))
            {
                Console.WriteLine($"Vet does not work on {date.ToString("ddd")}");
                return Ok(availableSlots);
            }

            // Parse start and end times using the vet's working hours
            if (!DateTime.TryParseExact($"{date:yyyy-MM-dd} " + timeRange.Split('-')[0], "yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime startTime) ||
                !DateTime.TryParseExact($"{date:yyyy-MM-dd} " + timeRange.Split('-')[1], "yyyy-MM-dd HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime endTime))
            {
                Console.WriteLine("Error parsing work hours.");
                return Ok(availableSlots);
            }

            // Fetch all appointments for this vet on the specified date
            var appointmentsForVet = await _context.Appointments
                .Where(a => a.VetId == vet.VetId && a.AppointmentDate.Date == date)
                .ToListAsync();

            // Determine available times by checking each slot for appointments
            while (startTime < endTime)
            {
                bool isAvailable = !appointmentsForVet.Any(a => a.AppointmentDate == startTime);
                Console.WriteLine($"Checking {startTime:HH:mm}: Available = {isAvailable}");

                if (isAvailable)
                {
                    availableSlots.AvailableTimes.Add(startTime);
                    Console.WriteLine($"Adding available slot: {startTime:HH:mm}");
                }
                else
                {
                    Console.WriteLine($"Skipping slot: {startTime:HH:mm} due to appointment.");
                }
                startTime = startTime.AddMinutes(30);
            }

            Console.WriteLine($"Total available slots: {availableSlots.AvailableTimes.Count}");

            return Ok(availableSlots);
        }

        private List<string> GetWorkingDays(string workSchedule)
        {
            List<string> workingDays = new List<string>();
            string days = workSchedule.Substring(0, workSchedule.IndexOf(';'));
            foreach (char day in days)
            {
                workingDays.Add(day.ToString());
            }
            return workingDays;
        }

        private string GetTimeRange(string workSchedule)
        {
            int semicolonIndex = workSchedule.IndexOf(';');
            return workSchedule.Substring(semicolonIndex + 1);
        }

        private string GetDayAbbreviation(string dayName)
        {
            var dayMap = new Dictionary<string, string>
            {
                {"MON", "M"}, {"TUE", "T"}, {"WED", "W"}, {"THU", "R"}, {"FRI", "F"}, {"SAT", "S"}, {"SUN", "U"}
            };
            return dayMap.TryGetValue(dayName, out string abbreviation) ? abbreviation : throw new ArgumentException("Invalid day of week abbreviation");
        }




    }

    public class AvailableSlotResource
    {
        public int VetId { get; set; }
        public string VetName { get; set; }
        public List<DateTime> AvailableTimes { get; set; }
    }



}
