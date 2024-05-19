using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly IProduct _productRepository;

        public ProductController(IProduct productRepository)
        {
            _productRepository = productRepository;
        }

        [HttpGet("{productId}")]
        public async Task<ActionResult<ProductResource>> GetProductById(int productId)
        {
            var product = await _productRepository.GetProductByIdAsync(productId);
            if (product == null)
            {
                return NotFound();
            }

            return Ok(product);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<ProductResource>>> GetAllProducts()
        {
            var products = await _productRepository.GetAllProductsAsync();
            return Ok(products);
        }

        [HttpPost]
        public async Task<ActionResult<ProductResource>> CreateProduct(ProductResource productResource)
        {
            var createdProduct = await _productRepository.CreateProductAsync(productResource);
            return CreatedAtAction(nameof(GetProductById), new { productId = createdProduct.ProductId }, createdProduct);
        }

        [HttpPut("{productId}")]
        public async Task<IActionResult> UpdateProduct(int productId, ProductResource productResource)
        {
            await _productRepository.UpdateProductAsync(productId, productResource);
            return Ok();
        }

        [HttpDelete("{productId}")]
        public async Task<IActionResult> DeleteProduct(int productId)
        {
            var result = await _productRepository.DeleteProductAsync(productId);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }
    }
}
