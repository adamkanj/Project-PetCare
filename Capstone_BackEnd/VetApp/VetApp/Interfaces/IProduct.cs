using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IProduct
    {
        Task<ProductResource> GetProductByIdAsync(int productId);
        Task<IEnumerable<ProductResource>> GetAllProductsAsync();
        Task<ProductResource> CreateProductAsync(ProductResource productResource);
        Task UpdateProductAsync(int productId, ProductResource productResource);
        Task<bool> DeleteProductAsync(int productId);
    }
}
