namespace VetApp.Resources
{
    public class OrderDetailResource
    {
        public int OrderDetailsId { get; set; }
        public int? OrderId { get; set; }
        public int? ProductId { get; set; }
        public int? Quantity { get; set; }
        public double? PriceUnit { get; set; }
    }
}
