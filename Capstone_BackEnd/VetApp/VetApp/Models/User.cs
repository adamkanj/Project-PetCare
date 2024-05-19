using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class User
    {
        public User()
        {
            Notifications = new HashSet<Notification>();
            PetOwners = new HashSet<PetOwner>();
            Veterinarians = new HashSet<Veterinarian>();
        }

        public int UserId { get; set; }
        public string? Username { get; set; }
        public string? Password { get; set; }
        public string? Email { get; set; }
        public string? Fn { get; set; }
        public string? Ln { get; set; }
        public string? Dob { get; set; }
        public string? Gender { get; set; }
        public string? Role { get; set; }

        public virtual ICollection<Notification> Notifications { get; set; }
        public virtual ICollection<PetOwner> PetOwners { get; set; }
        public virtual ICollection<Veterinarian> Veterinarians { get; set; }
    }
}
