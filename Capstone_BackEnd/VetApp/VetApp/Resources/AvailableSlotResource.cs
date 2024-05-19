namespace VetApp.Resources
{
    public class AvailableSlotResource
    {
        public int VetId { get; set; }
        public string VetName { get; set; }
        public List<DateTime> AvailableTimes { get; set; }
    }

}
