using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class Appointment
    {
        public int AppointmentId { get; set; }
        public int? OwnerId { get; set; }
        public int? VetId { get; set; }
        public int? PetId { get; set; }
        public String? Description { get; set; }
        public DateTime AppointmentDate { get; set; } 
        public string? Category { get; set; }
        public string? Status { get; set; }

        public virtual PetOwner? Owner { get; set; }
        public virtual Veterinarian? Vet { get; set; }
        public virtual Pet? Pet { get; set; }

    }
}
