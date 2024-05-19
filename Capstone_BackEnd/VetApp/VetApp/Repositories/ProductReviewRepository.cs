using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Models;
using VetApp.Resources;

namespace VetApp.Repositories
{
    public class ProductReviewRepository : IProductReview
    {
        private readonly VetAppContext _context;

        public ProductReviewRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<ProductReviewResource> GetProductReviewByIdAsync(int productReviewId)
        {
            var productReview = await _context.ProductReviews.FindAsync(productReviewId);
            return productReview != null ? MapProductReviewToResource(productReview) : null;
        }

        public async Task<IEnumerable<ProductReviewResource>> GetAllProductReviewsAsync()
        {
            var productReviews = await _context.ProductReviews.ToListAsync();
            return productReviews.Select(pr => MapProductReviewToResource(pr));
        }

        public async Task<ProductReviewResource> CreateProductReviewAsync(ProductReviewResource productReviewResource)
        {
            var productReview = new ProductReview
            {
                OwnerId = productReviewResource.OwnerId,
                ProductId = productReviewResource.ProductId,
                Rating = productReviewResource.Rating,
                Comment = productReviewResource.Comment,
                Date = productReviewResource.Date
            };

            _context.ProductReviews.Add(productReview);
            await _context.SaveChangesAsync();

            return MapProductReviewToResource(productReview);
        }

        public async Task UpdateProductReviewAsync(int productReviewId, ProductReviewResource productReviewResource)
        {
            var productReview = await _context.ProductReviews.FindAsync(productReviewId);
            if (productReview == null)
            {
                throw new Exception($"Product review with ID {productReviewId} not found");
            }

            productReview.OwnerId = productReviewResource.OwnerId;
            productReview.ProductId = productReviewResource.ProductId;
            productReview.Rating = productReviewResource.Rating;
            productReview.Comment = productReviewResource.Comment;
            productReview.Date = productReviewResource.Date;

            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteProductReviewAsync(int productReviewId)
        {
            var productReview = await _context.ProductReviews.FindAsync(productReviewId);
            if (productReview == null)
            {
                return false;
            }

            _context.ProductReviews.Remove(productReview);
            await _context.SaveChangesAsync();
            return true;
        }

        private ProductReviewResource MapProductReviewToResource(ProductReview productReview)
        {
            return new ProductReviewResource
            {
                ProductReviewId = productReview.ProductReviewId,
                OwnerId = productReview.OwnerId,
                ProductId = productReview.ProductId,
                Rating = productReview.Rating,
                Comment = productReview.Comment,
                Date = productReview.Date
            };
        }

        public async Task<IEnumerable<VetReview>> GetReviewsByproductId(int ProductId)
        {
            return await _context.ProductReviews
                .Where(r => r.ProductId == ProductId)
                .Select(r => new VetReview
                {
                    FirstName = r.Owner.User.Fn,
                    LastName = r.Owner.User.Ln,
                    Rating = r.Rating ?? 0,
                    Comment = r.Comment,
                    Date = r.Date ?? DateTime.Now,
                })
                .ToListAsync();
        }
    }
}
