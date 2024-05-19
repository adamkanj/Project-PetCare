using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface ICart
    {
        Task<CartResource> GetCartByIdAsync(int cartId);
        Task<IEnumerable<CartResource>> GetAllCartsAsync();
        Task<CartResource> CreateOrUpdateCartAsync(CartResource cartResource);
        Task<bool> DeleteCartAsync(int cartId);
        Task<bool> DeleteAllCartsByOwnerIdAsync(int ownerId);
    }
}
