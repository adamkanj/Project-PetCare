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
    public class ProductRepository : IProduct
    {
        private readonly VetAppContext _context;

        public ProductRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<ProductResource> GetProductByIdAsync(int productId)
        {
            var product = await _context.Products.FindAsync(productId);
            return product != null ? MapProductToResource(product) : null;
        }

        public async Task<IEnumerable<ProductResource>> GetAllProductsAsync()
        {
            var products = await _context.Products.ToListAsync();
            return products.Select(p => MapProductToResource(p));
        }

        public async Task<ProductResource> CreateProductAsync(ProductResource productResource)
        {
            var product = new Product
            {
                Name = productResource.Name,
                Description = productResource.Description,
                Price = productResource.Price,
                Quantity = productResource.Quantity,
                Category = productResource.Category,
                PetGenre = productResource.PetGenre,
                Image = productResource.Image
            };

            _context.Products.Add(product);
            await _context.SaveChangesAsync();

            return MapProductToResource(product);
        }

        public async Task UpdateProductAsync(int productId, ProductResource productResource)
        {
            var product = await _context.Products.FindAsync(productId);
            if (product == null)
            {
                throw new Exception($"Product with ID {productId} not found");
            }

            product.Name = productResource.Name;
            product.Description = productResource.Description;
            product.Price = productResource.Price;
            product.Quantity = productResource.Quantity;
            product.Category = productResource.Category;
            product.PetGenre = productResource.PetGenre;
            product.Image = productResource.Image;

            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteProductAsync(int productId)
        {
            var product = await _context.Products.FindAsync(productId);
            if (product == null)
            {
                return false;
            }

            _context.Products.Remove(product);
            await _context.SaveChangesAsync();
            return true;
        }

        private ProductResource MapProductToResource(Product product)
        {
            return new ProductResource
            {
                ProductId = product.ProductId,
                Name = product.Name,
                Description = product.Description,
                Price = product.Price,
                Quantity = product.Quantity,
                Category = product.Category,
                PetGenre = product.PetGenre,
                Image = product.Image
            };
        }
    }
}
