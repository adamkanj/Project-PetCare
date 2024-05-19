using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewController : ControllerBase
    {
        private readonly IReview _reviewRepository;

        public ReviewController(IReview reviewRepository)
        {
            _reviewRepository = reviewRepository;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ReviewResource>>> GetAllReviews()
        {
            var reviews = await _reviewRepository.GetAllReviewsAsync();
            return Ok(reviews);
        }

        [HttpGet("{reviewId}")]
        public async Task<ActionResult<ReviewResource>> GetReviewById(int reviewId)
        {
            var review = await _reviewRepository.GetReviewByIdAsync(reviewId);
            if (review == null)
            {
                return NotFound();
            }

            return Ok(review);
        }

        [HttpPost]
        public async Task<ActionResult<ReviewResource>> CreateReview(ReviewResource reviewResource)
        {
            var createdReview = await _reviewRepository.CreateReviewAsync(reviewResource);
            return CreatedAtAction(nameof(GetReviewById), new { reviewId = createdReview.ReviewId }, createdReview);
        }

        [HttpPut("{reviewId}")]
        public async Task<IActionResult> UpdateReview(int reviewId, ReviewResource reviewResource)
        {
            try
            {
                await _reviewRepository.UpdateReviewAsync(reviewId, reviewResource);
                return Ok();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error updating review: {ex.Message}");
                return StatusCode(500, "An error occurred while updating the review.");
            }
        }

        [HttpDelete("{reviewId}")]
        public async Task<IActionResult> DeleteReview(int reviewId)
        {
            var result = await _reviewRepository.DeleteReviewAsync(reviewId);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }

        [HttpGet("vet/{vetId}")]
        public async Task<ActionResult<IEnumerable<VetReview>>> GetReviewsByVetId(int vetId)
        {
            try
            {
                var reviews = await _reviewRepository.ViewReviewsByVetId(vetId);
                return Ok(reviews);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
