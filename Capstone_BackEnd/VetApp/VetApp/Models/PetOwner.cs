using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class PetOwner
    {
        public PetOwner()
        {
            Appointments = new HashSet<Appointment>();
            Carts = new HashSet<Cart>();
            Orders = new HashSet<Order>();
            Pets = new HashSet<Pet>();
            ProductReviews = new HashSet<ProductReview>();
            Reviews = new HashSet<Review>();
        }

        public int OwnerId { get; set; }
        public int? UserId { get; set; }
        public string? Address { get; set; }

        public virtual User? User { get; set; }
        public virtual ICollection<Appointment> Appointments { get; set; }
        public virtual ICollection<Cart> Carts { get; set; }
        public virtual ICollection<Order> Orders { get; set; }
        public virtual ICollection<Pet> Pets { get; set; }
        public virtual ICollection<ProductReview> ProductReviews { get; set; }
        public virtual ICollection<Review> Reviews { get; set; }
    }
}
