using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IOrder
    {
        Task<OrderResource> CreateOrderAsync(OrderResource orderResource);
        Task<OrderResource> GetOrderByIdAsync(int orderId);
        Task<IQueryable<OrderResource>> GetAllOrdersAsync();
        Task DeleteOrderAsync(int orderId);
    }
}
