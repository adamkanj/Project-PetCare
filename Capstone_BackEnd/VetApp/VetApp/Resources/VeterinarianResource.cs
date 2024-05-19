namespace VetApp.Resources
{
    public class VeterinarianResource
    {
        public int VetId { get; set; }
        public int? UserId { get; set; }
        public string? Specialty { get; set; }
        public string? WorkSchedule { get; set; }
        public string? Qualifications { get; set; }
        public string? YearsExperience { get; set; }
        public byte[]? Image { get; set; }

        // User attributes
        public string Username { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public string Fn { get; set; }
        public string Ln { get; set; }
        public string Dob { get; set; }
        public string Gender { get; set; }
        public string Role { get; set; }
    }
}
