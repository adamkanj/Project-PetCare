using System;
using System.Collections.Generic;
using VetApp.Interfaces;

namespace VetApp.Models
{
    public partial class Pet
    {
        public Pet()
        {
            MedicalRecords = new HashSet<MedicalRecord>();
            Notifications = new HashSet<Notification>();
            Vaccinations = new HashSet<Vaccination>();
            Appointments = new HashSet<Appointment>();

        }

        public int PetId { get; set; }
        public int OwnerId { get; set; }
        public string Name { get; set; }
        public string? Species { get; set; }
        public string? Breed { get; set; }
        public string? Gender { get; set; }
        public DateTime? Dob { get; set; }
        public byte[]? Image { get; set; }

        public virtual PetOwner? Owner { get; set; }

        public virtual ICollection<MedicalRecord> MedicalRecords { get; set; }
        public virtual ICollection<Notification> Notifications { get; set; }
        public virtual ICollection<Vaccination> Vaccinations { get; set; }
        public virtual ICollection<Appointment> Appointments { get; set; }


    }
}
