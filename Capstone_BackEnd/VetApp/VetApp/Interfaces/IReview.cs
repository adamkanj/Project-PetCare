using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IReview
    {
        Task<IEnumerable<ReviewResource>> GetAllReviewsAsync();
        Task<ReviewResource> GetReviewByIdAsync(int reviewId);
        Task<ReviewResource> CreateReviewAsync(ReviewResource reviewResource);
        Task UpdateReviewAsync(int reviewId, ReviewResource reviewResource);
        Task<bool> DeleteReviewAsync(int reviewId);
        Task<IEnumerable<VetReview>> ViewReviewsByVetId(int vetId);

    }
}
