namespace VetApp.Resources
{
    public class EquipmentResource
    {
        public int EquipmentId { get; set; }
        public string? Name { get; set; }
        public int? Quantity { get; set; }
        public string? Category { get; set; }
        public DateTime? LastScanDate { get; set; }
        public DateTime? NextScanDate { get; set; }
    }
}
