namespace VetApp.Resources
{
    public class NotificationResource
    {
        public int NotificationId { get; set; }
        public int? UserId { get; set; }
        public string? Title { get; set; }
        public string? Content { get; set; }
        public DateTime? Timestamp { get; set; } 


    }
}
