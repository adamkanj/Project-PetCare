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
    public class CartRepository : ICart
    {
        private readonly VetAppContext _context;

        public CartRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<CartResource> GetCartByIdAsync(int cartId)
        {
            var cart = await _context.Carts.FindAsync(cartId);
            return cart != null ? MapCartToResource(cart) : null;
        }

        public async Task<IEnumerable<CartResource>> GetAllCartsAsync()
        {
            var carts = await _context.Carts.ToListAsync();
            return carts.Select(c => MapCartToResource(c));
        }

        public async Task<CartResource> CreateOrUpdateCartAsync(CartResource cartResource)
        {
            var existingCart = await _context.Carts.FirstOrDefaultAsync(c => c.OwnerId == cartResource.OwnerId && c.ProductId == cartResource.ProductId);
            if (existingCart != null)
            {
                existingCart.Quantity += cartResource.Quantity;
                existingCart.Timestamp = cartResource.Timestamp;
            }
            else
            {
                var newCart = new Cart
                {
                    OwnerId = cartResource.OwnerId,
                    ProductId = cartResource.ProductId,
                    Quantity = cartResource.Quantity,
                    Timestamp = cartResource.Timestamp
                };
                _context.Carts.Add(newCart);
            }

            await _context.SaveChangesAsync();

            return cartResource;
        }


        public async Task<bool> DeleteAllCartsByOwnerIdAsync(int ownerId)
        {
            var carts = await _context.Carts.Where(c => c.OwnerId == ownerId).ToListAsync();
            if (carts == null || !carts.Any())
            {
                return false;
            }

            _context.Carts.RemoveRange(carts);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteCartAsync(int cartId)
        {
            var cart = await _context.Carts.FindAsync(cartId);
            if (cart == null)
            {
                return false;
            }

            _context.Carts.Remove(cart);
            await _context.SaveChangesAsync();
            return true;
        }

        private CartResource MapCartToResource(Cart cart)
        {
            return new CartResource
            {
                CartId = cart.CartId,
                OwnerId = cart.OwnerId,
                ProductId = cart.ProductId,
                Quantity = cart.Quantity,
                Timestamp = cart.Timestamp
            };
        }

    }
}
