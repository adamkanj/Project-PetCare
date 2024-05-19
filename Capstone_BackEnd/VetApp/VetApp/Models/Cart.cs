using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class Cart
    {
        public int CartId { get; set; }
        public int? OwnerId { get; set; }
        public int? ProductId { get; set; }
        public int? Quantity { get; set; }
        public byte[]? Timestamp { get; set; } 
        public virtual PetOwner? Owner { get; set; }
        public virtual Product? Product { get; set; }
    }
}
