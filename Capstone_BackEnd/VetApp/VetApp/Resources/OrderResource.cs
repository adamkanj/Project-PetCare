namespace VetApp.Resources
{
    public class OrderResource
    {
        public int OrderId { get; set; }
        public int? OwnerId { get; set; }
        public DateTime? OrderDate { get; set; }
        public double? TotalAmount { get; set; }
        public string? Address { get; set; }
        public string? PaymentMethod { get; set; }
        public string? Status { get; set; }

    }
}
