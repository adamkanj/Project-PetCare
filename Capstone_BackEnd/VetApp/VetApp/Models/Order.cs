using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class Order
    {
        public Order()
        {
            OrderDetails = new HashSet<OrderDetail>();
        }

        public int OrderId { get; set; }
        public int? OwnerId { get; set; }
        public DateTime? OrderDate { get; set; }
        public double? TotalAmount { get; set; }
        public string? Address { get; set; }
        public string? PaymentMethod { get; set; }
        public string? Status { get; set; }

        public virtual PetOwner? Owner { get; set; }
        public virtual ICollection<OrderDetail> OrderDetails { get; set; }
    }
}
