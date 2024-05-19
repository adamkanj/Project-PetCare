namespace VetApp.Resources
{
    public class VaccinationResource
    {
        public int VaccinationId { get; set; }
        public int PetId { get; set; }
        public string? VaccineName { get; set; }
        public string? Notes { get; set; }
        public DateTime? DateAdministered { get; set; }
        public DateTime? NextDueDate { get; set; }
        public string? Status { get; set; }
    }
}
