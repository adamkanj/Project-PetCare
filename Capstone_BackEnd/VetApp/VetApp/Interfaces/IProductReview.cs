using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IProductReview
    {
        Task<ProductReviewResource> GetProductReviewByIdAsync(int productReviewId);
        Task<IEnumerable<ProductReviewResource>> GetAllProductReviewsAsync();
        Task<ProductReviewResource> CreateProductReviewAsync(ProductReviewResource productReviewResource);
        Task UpdateProductReviewAsync(int productReviewId, ProductReviewResource productReviewResource);
        Task<bool> DeleteProductReviewAsync(int productReviewId);
        Task<IEnumerable<VetReview>> GetReviewsByproductId(int ProductId);

    }
}
