using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using VetApp.Interfaces;
using VetApp.Models;

namespace VetApp.Repositories
{
    public class AdminRepository : IAdmin
    {
        private readonly VetAppContext _context;

        public AdminRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<User>> GetAllAsync()
        {
            return await _context.Users.Where(u => u.Role == "Admin").ToListAsync();
        }

        public async Task<User> GetByIdAsync(int id)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.UserId == id && u.Role == "Admin");
        }

        public async Task<User> AddAsync(User user)
        {
            user.Role = "Admin"; // Ensure role is set to "Admin"
            _context.Users.Add(user);
            await _context.SaveChangesAsync();
            return user;
        }

        public async Task<User> UpdateAsync(User user)
        {
            _context.Entry(user).State = EntityState.Modified;
            await _context.SaveChangesAsync();
            return user;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var user = await _context.Users.FirstOrDefaultAsync(u => u.UserId == id && u.Role == "Admin");
            if (user == null)
                return false;

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return true;
        }
    }
}
