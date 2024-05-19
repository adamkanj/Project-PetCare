using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class Review
    {
        public int ReviewId { get; set; }
        public int? OwnerId { get; set; }
        public int? VetId { get; set; }
        public int? Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime? Date { get; set; }

        public virtual PetOwner? Owner { get; set; }
        public virtual Veterinarian? Vet { get; set; }
    }
}
