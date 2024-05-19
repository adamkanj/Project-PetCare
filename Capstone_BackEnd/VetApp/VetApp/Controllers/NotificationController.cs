using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationController : ControllerBase
    {
        private readonly INotification _notificationRepository;

        public NotificationController(INotification notificationRepository)
        {
            _notificationRepository = notificationRepository;
        }

        [HttpGet("{notificationId}")]
        public async Task<ActionResult<NotificationResource>> GetNotificationById(int notificationId)
        {
            var notification = await _notificationRepository.GetNotificationByIdAsync(notificationId);
            if (notification == null)
            {
                return NotFound();
            }

            return Ok(notification);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<NotificationResource>>> GetAllNotifications()
        {
            var notifications = await _notificationRepository.GetAllNotificationsAsync();
            return Ok(notifications);
        }

        [HttpPost]
        public async Task<ActionResult<NotificationResource>> CreateNotification(NotificationResource notificationResource)
        {
            var createdNotification = await _notificationRepository.CreateNotificationAsync(notificationResource);
            return CreatedAtAction(nameof(GetNotificationById), new { notificationId = createdNotification.NotificationId }, createdNotification);
        }

        [HttpPut("{notificationId}")]
        public async Task<IActionResult> UpdateNotification(int notificationId, NotificationResource notificationResource)
        {
            await _notificationRepository.UpdateNotificationAsync(notificationId, notificationResource);
            return Ok();
        }

        [HttpDelete("{notificationId}")]
        public async Task<IActionResult> DeleteNotification(int notificationId)
        {
            var result = await _notificationRepository.DeleteNotificationAsync(notificationId);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }
    }
}
