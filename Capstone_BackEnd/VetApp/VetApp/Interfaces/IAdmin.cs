using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Models;

namespace VetApp.Interfaces
{
    public interface IAdmin
    {
        Task<IEnumerable<User>> GetAllAsync();
        Task<User> GetByIdAsync(int id);
        Task<User> AddAsync(User user);
        Task<User> UpdateAsync(User user);
        Task<bool> DeleteAsync(int id);
    }
}
