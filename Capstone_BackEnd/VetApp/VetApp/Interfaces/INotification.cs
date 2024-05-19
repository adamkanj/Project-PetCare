using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface INotification
    {
        Task<NotificationResource> GetNotificationByIdAsync(int notificationId);
        Task<IEnumerable<NotificationResource>> GetAllNotificationsAsync();
        Task<NotificationResource> CreateNotificationAsync(NotificationResource notificationResource);
        Task UpdateNotificationAsync(int notificationId, NotificationResource notificationResource);
        Task<bool> DeleteNotificationAsync(int notificationId);
    }
}
