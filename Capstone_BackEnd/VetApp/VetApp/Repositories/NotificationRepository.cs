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
    public class NotificationRepository : INotification
    {
        private readonly VetAppContext _context;

        public NotificationRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<NotificationResource> GetNotificationByIdAsync(int notificationId)
        {
            var notification = await _context.Notifications.FindAsync(notificationId);
            return notification != null ? MapNotificationToResource(notification) : null;
        }

        public async Task<IEnumerable<NotificationResource>> GetAllNotificationsAsync()
        {
            var notifications = await _context.Notifications.ToListAsync();
            return notifications.Select(n => MapNotificationToResource(n));
        }

        public async Task<NotificationResource> CreateNotificationAsync(NotificationResource notificationResource)
        {
            var notification = new Notification
            {
                UserId = notificationResource.UserId,
                Title = notificationResource.Title,
                Content = notificationResource.Content,
                Timestamp = notificationResource.Timestamp
            };

            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();

            return MapNotificationToResource(notification);
        }

        public async Task UpdateNotificationAsync(int notificationId, NotificationResource notificationResource)
        {
            var notification = await _context.Notifications.FindAsync(notificationId);
            if (notification == null)
            {
                throw new Exception($"Notification with ID {notificationId} not found");
            }

            notification.UserId = notificationResource.UserId;
            notification.Title = notificationResource.Title;
            notification.Content = notificationResource.Content;
            notification.Timestamp = notificationResource.Timestamp;

            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteNotificationAsync(int notificationId)
        {
            var notification = await _context.Notifications.FindAsync(notificationId);
            if (notification == null)
            {
                return false;
            }

            _context.Notifications.Remove(notification);
            await _context.SaveChangesAsync();
            return true;
        }

        private NotificationResource MapNotificationToResource(Notification notification)
        {
            return new NotificationResource
            {
                NotificationId = notification.NotificationId,
                UserId = notification.UserId,
                Title = notification.Title,
                Content = notification.Content,
                Timestamp = notification.Timestamp
            };
        }
    }
}
