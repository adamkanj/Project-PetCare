using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class Veterinarian
    {
        public Veterinarian()
        {
            Appointments = new HashSet<Appointment>();
            Reviews = new HashSet<Review>();
        }

        public int VetId { get; set; }
        public int? UserId { get; set; }
        public string? Specialty { get; set; }
        public string? WorkSchedule { get; set; }
        public string? Qualifications { get; set; }
        public string? YearsExperience { get; set; }
        public byte[]? Image { get; set; }

        public virtual User? User { get; set; }
        public virtual ICollection<Appointment> Appointments { get; set; }
        public virtual ICollection<Review> Reviews { get; set; }
    }
}
