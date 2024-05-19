using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IAppointment
    {
        Task<IEnumerable<AppointmentResource>> GetAllAppointmentsAsync();
        Task<AppointmentResource> GetAppointmentByIdAsync(int id);
        Task<IEnumerable<AppointmentResource>> GetAppointmentsByVetIdAsync(int vetId);
        Task<IEnumerable<AppointmentResource>> GetAppointmentsByOwnerIdAsync(int ownerId);
        Task<IEnumerable<AppointmentResource>> GetAvailableAppointmentsAsync(int vetId, DateTime startDate, DateTime endDate);
        Task<bool> IsAppointmentAvailableAsync(int vetId, DateTime appointmentDate);
        Task<bool> CreateAppointmentAsync(AppointmentResource appointmentResource);
        Task<bool> UpdateAppointmentAsync(int appointmentId, AppointmentResource appointmentResource);
        Task DeleteAppointmentAsync(int appointmentId);
    }
}
