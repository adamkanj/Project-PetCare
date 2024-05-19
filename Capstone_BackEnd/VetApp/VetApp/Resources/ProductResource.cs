namespace VetApp.Resources
{
    public class ProductResource
    {
        public int ProductId { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
        public double? Price { get; set; }
        public int? Quantity { get; set; }
        public string? Category { get; set; }
        public string? PetGenre { get; set; }
        public byte[]? Image { get; set; }
    }
}
