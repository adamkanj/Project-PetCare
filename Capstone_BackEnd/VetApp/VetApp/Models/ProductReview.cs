using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class ProductReview
    {
        public int ProductReviewId { get; set; }
        public int? OwnerId { get; set; }
        public int? ProductId { get; set; }
        public int? Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime? Date { get; set; }

        public virtual PetOwner? Owner { get; set; }
        public virtual Product? Product { get; set; }
    }
}
