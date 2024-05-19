using AutoMapper;
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
    public class ReviewRepository : IReview
    {
        private readonly VetAppContext _context;
        private readonly IMapper _mapper;

        public ReviewRepository(VetAppContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<IEnumerable<ReviewResource>> GetAllReviewsAsync()
        {
            var reviews = await _context.Reviews.ToListAsync();
            return _mapper.Map<IEnumerable<ReviewResource>>(reviews);
        }

        public async Task<ReviewResource> GetReviewByIdAsync(int reviewId)
        {
            var review = await _context.Reviews.FindAsync(reviewId);
            return _mapper.Map<ReviewResource>(review);
        }

        public async Task<ReviewResource> CreateReviewAsync(ReviewResource reviewResource)
        {
            var review = _mapper.Map<Review>(reviewResource);
            _context.Reviews.Add(review);
            await _context.SaveChangesAsync();
            return _mapper.Map<ReviewResource>(review);
        }

        public async Task UpdateReviewAsync(int reviewId, ReviewResource reviewResource)
        {
            var existingReview = await _context.Reviews.FindAsync(reviewId);
            if (existingReview == null)
            {
                throw new Exception($"Review with ID {reviewId} not found");
            }

            _mapper.Map(reviewResource, existingReview);

            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteReviewAsync(int reviewId)
        {
            var review = await _context.Reviews.FindAsync(reviewId);
            if (review == null)
            {
                return false;
            }

            _context.Reviews.Remove(review);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<IEnumerable<VetReview>> ViewReviewsByVetId(int vetId)
        {
            return await _context.Reviews
                .Where(r => r.VetId == vetId)
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
