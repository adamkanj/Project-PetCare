using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Resources;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CartController : ControllerBase
    {
        private readonly ICart _cartRepository;

        public CartController(ICart cartRepository)
        {
            _cartRepository = cartRepository;
        }

        [HttpGet("{cartId}")]
        public async Task<ActionResult<CartResource>> GetCartById(int cartId)
        {
            var cart = await _cartRepository.GetCartByIdAsync(cartId);
            if (cart == null)
            {
                return NotFound();
            }

            return Ok(cart);
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<CartResource>>> GetAllCarts()
        {
            var carts = await _cartRepository.GetAllCartsAsync();
            return Ok(carts);
        }

        [HttpPost]
        public async Task<ActionResult<CartResource>> CreateOrUpdateCart(CartResource cartResource)
        {
            var createdOrUpdatedCart = await _cartRepository.CreateOrUpdateCartAsync(cartResource);
            return CreatedAtAction(nameof(GetCartById), new { cartId = createdOrUpdatedCart.CartId }, createdOrUpdatedCart);
        }

        [HttpDelete("{cartId}")]
        public async Task<IActionResult> DeleteCart(int cartId)
        {
            var result = await _cartRepository.DeleteCartAsync(cartId);
            if (!result)
            {
                return NotFound();
            }

            return NoContent();
        }
    }
}
