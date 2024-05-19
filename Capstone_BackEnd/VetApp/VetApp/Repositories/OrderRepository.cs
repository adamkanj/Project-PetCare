using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using VetApp.Interfaces;
using VetApp.Models;
using VetApp.Resources;

namespace VetApp.Repositories
{
    public class OrderRepository : IOrder
    {
        private readonly VetAppContext _context;

        public OrderRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<OrderResource> CreateOrderAsync(OrderResource orderResource)
        {
            // Create a new order
            var newOrder = new Order
            {
                OwnerId = orderResource.OwnerId,
                OrderDate = DateTime.Now, // Set order date to current time
                Address = orderResource.Address,
                PaymentMethod = orderResource.PaymentMethod,
                Status = "Pending" // Set status to "Pending"
            };

            // Compute total amount
            var cartItems = await _context.Carts
                .Where(c => c.OwnerId == orderResource.OwnerId)
                .ToListAsync();

            double totalAmount = 0;
            foreach (var item in cartItems)
            {
                var product = await _context.Products.FindAsync(item.ProductId);
                totalAmount += (double)(item.Quantity * (product?.Price ?? 0));
            }

            newOrder.TotalAmount = totalAmount;

            // Add the new order to the database
            _context.Orders.Add(newOrder);
            await _context.SaveChangesAsync();

            // Move cart items to order details
            foreach (var item in cartItems)
            {
                var newOrderDetail = new OrderDetail
                {
                    OrderId = newOrder.OrderId,
                    ProductId = item.ProductId,
                    Quantity = item.Quantity,
                    PriceUnit = _context.Products.Find(item.ProductId)?.Price
                };

                _context.OrderDetails.Add(newOrderDetail);
            }

            // Delete cart items
            _context.Carts.RemoveRange(cartItems);
            await _context.SaveChangesAsync();

            return orderResource;
        }

        public async Task<OrderResource> GetOrderByIdAsync(int orderId)
        {
            var order = await _context.Orders.FindAsync(orderId);
            if (order == null)
            {
                throw new Exception($"Order with ID {orderId} not found");
            }

            // Map Order entity to OrderResource
            var orderResource = new OrderResource
            {
                OrderId = order.OrderId,
                OwnerId = order.OwnerId,
                OrderDate = order.OrderDate,
                TotalAmount = order.TotalAmount,
                Address = order.Address,
                PaymentMethod = order.PaymentMethod,
                Status = order.Status
            };

            return orderResource;
        }

        public async Task<IQueryable<OrderResource>> GetAllOrdersAsync()
        {
            // Get all orders from the database
            var orders = await _context.Orders.ToListAsync();

            // Map Order entities to OrderResources
            var orderResources = orders.Select(order => new OrderResource
            {
                OrderId = order.OrderId,
                OwnerId = order.OwnerId,
                OrderDate = order.OrderDate,
                TotalAmount = order.TotalAmount,
                Address = order.Address,
                PaymentMethod = order.PaymentMethod,
                Status = order.Status
            }).AsQueryable();

            return orderResources;
        }

        public async Task DeleteOrderAsync(int orderId)
        {
            // Find the order by ID
            var order = await _context.Orders.FindAsync(orderId);
            if (order == null)
            {
                throw new Exception($"Order with ID {orderId} not found");
            }

            // Remove the order from the database
            _context.Orders.Remove(order);
            await _context.SaveChangesAsync();
        }
    }
}
