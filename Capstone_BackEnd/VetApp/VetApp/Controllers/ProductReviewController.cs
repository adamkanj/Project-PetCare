using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Repositories;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductReviewController : ControllerBase
    {
        private readonly IProductReview _productReviewRepository;

        public ProductReviewController(IProductReview productReviewRepository)
        {
            _productReviewRepository = productReviewRepository;
        }

        [HttpGet("{productReviewId}")]
        public async Task<ActionResult<ProductReviewResource>> GetProductReviewById(int productReviewId)
        {
            var productReview = await _productReviewRepository.GetProductReviewByIdAsync(productReviewId);
            if (productReview == null)
            {
                return NotFound();
            }

            return Ok(productReview);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ProductReviewResource>>> GetAllProductReviews()
        {
            var productReviews = await _productReviewRepository.GetAllProductReviewsAsync();
            return Ok(productReviews);
        }

        [HttpPost]
        public async Task<ActionResult<ProductReviewResource>> CreateProductReview(ProductReviewResource productReviewResource)
        {
            var createdProductReview = await _productReviewRepository.CreateProductReviewAsync(productReviewResource);
            return CreatedAtAction(nameof(GetProductReviewById), new { productReviewId = createdProductReview.ProductReviewId }, createdProductReview);
        }

        [HttpPut("{productReviewId}")]
        public async Task<IActionResult> UpdateProductReview(int productReviewId, ProductReviewResource productReviewResource)
        {
            await _productReviewRepository.UpdateProductReviewAsync(productReviewId, productReviewResource);
            return Ok();
        }

        [HttpDelete("{productReviewId}")]
        public async Task<IActionResult> DeleteProductReview(int productReviewId)
        {
            var result = await _productReviewRepository.DeleteProductReviewAsync(productReviewId);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }

        [HttpGet("Product/{ProductId}")]
        public async Task<ActionResult<IEnumerable<VetReview>>> GetReviewsByproductId(int ProductId)
        {
            try
            {
                var reviews = await _productReviewRepository.GetReviewsByproductId(ProductId);
                return Ok(reviews);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}
