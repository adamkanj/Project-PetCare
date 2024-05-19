namespace VetApp.Resources
{
    public class PetDetails
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Breed { get; set; }
        public byte[]? Image { get; set; } // Image as byte array
        public string OwnerName { get; set; }
        public DateTime? DOB { get; set; }
    }

}
