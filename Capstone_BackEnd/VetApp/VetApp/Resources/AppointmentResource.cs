namespace VetApp.Resources
{
    public class AppointmentResource
    {
        public int AppointmentId { get; set; }
        public int? OwnerId { get; set; }
        public int? VetId { get; set; }
        public int? PetId { get; set; }
        public String? Description { get; set; }
        public DateTime AppointmentDate { get; set; }
        public string? Category { get; set; }
        public string? Status { get; set; }
    }
}
