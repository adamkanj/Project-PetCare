namespace VetApp.Resources
{
    public class PetResource
    {
        public int PetId { get; set; }
        public int OwnerId { get; set; }
        public string Name { get; set; }
        public string? Species { get; set; }
        public string? Breed { get; set; }
        public string? Gender { get; set; }
        public DateTime? Dob { get; set; }
        public byte[]? Image { get; set; }
    }
}
