namespace VetApp.Resources
{
    public class RegistrationAttempt
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public string Fn { get; set; }
        public string Ln { get; set; }
        public String Dob { get; set; }
        public string Gender { get; set; }
        public string Address { get; set; }

        public string VerificationCode { get; set; }
        public string RegistrationKey { get; set; }
        public bool IsVerified { get; set; } = false;


    }
}
