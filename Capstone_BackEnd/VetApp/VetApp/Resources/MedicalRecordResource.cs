namespace VetApp.Resources
{
    public class MedicalRecordResource
    {
        public int RecordId { get; set; }
        public int? PetId { get; set; }
        public string? Description { get; set; }
        public string? Service { get; set; }
        public byte[]? TestResults { get; set; }
        public DateTime? Date { get; set; }
        public string? Status { get; set; }
    }
}
