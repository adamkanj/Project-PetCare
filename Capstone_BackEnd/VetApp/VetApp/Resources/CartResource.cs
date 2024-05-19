namespace VetApp.Resources
{
    public class CartResource
    {
        public int CartId { get; set; }
        public int? OwnerId { get; set; }
        public int? ProductId { get; set; }
        public int? Quantity { get; set; }
        public byte[]? Timestamp { get; set; } // Change the type to DateTime
    }
}
