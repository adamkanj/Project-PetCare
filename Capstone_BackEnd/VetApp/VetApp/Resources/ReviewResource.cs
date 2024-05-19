namespace VetApp.Resources
{
    public class ReviewResource
    {
        public int ReviewId { get; set; }
        public int? OwnerId { get; set; }
        public int? VetId { get; set; }
        public int? Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime? Date { get; set; }
    }
}
