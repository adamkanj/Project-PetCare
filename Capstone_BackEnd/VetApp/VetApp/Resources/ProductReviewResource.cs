namespace VetApp.Resources
{
    public class ProductReviewResource
    {
        public int ProductReviewId { get; set; }
        public int? OwnerId { get; set; }
        public int? ProductId { get; set; }
        public int? Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime? Date { get; set; }
    }
}
