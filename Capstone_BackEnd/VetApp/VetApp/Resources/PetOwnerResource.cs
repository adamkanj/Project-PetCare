namespace VetApp.Resources
{
    public class PetOwnerResource
    {
        public int OwnerId { get; set; }
        public int? UserId { get; set; }
        public string Address { get; set; }

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
