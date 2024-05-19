using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class Product
    {
        public Product()
        {
            Carts = new HashSet<Cart>();
            OrderDetails = new HashSet<OrderDetail>();
            ProductReviews = new HashSet<ProductReview>();
        }

        public int ProductId { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
        public double? Price { get; set; }
        public int? Quantity { get; set; }
        public string? Category { get; set; }
        public string? PetGenre { get; set; }
        public byte[]? Image { get; set; }

        public virtual ICollection<Cart> Carts { get; set; }
        public virtual ICollection<OrderDetail> OrderDetails { get; set; }
        public virtual ICollection<ProductReview> ProductReviews { get; set; }
    }
}
