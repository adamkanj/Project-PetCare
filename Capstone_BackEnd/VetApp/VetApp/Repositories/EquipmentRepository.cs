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
    public class EquipmentRepository : IEquipment
    {
        private readonly VetAppContext _context;

        public EquipmentRepository(VetAppContext context)
        {
            _context = context;
        }

        public async Task<EquipmentResource> GetEquipmentByIdAsync(int equipmentId)
        {
            var equipment = await _context.Equipments.FindAsync(equipmentId);
            return equipment != null ? MapEquipmentToResource(equipment) : null;
        }

        public async Task<IEnumerable<EquipmentResource>> GetAllEquipmentAsync()
        {
            var equipment = await _context.Equipments.ToListAsync();
            return equipment.Select(e => MapEquipmentToResource(e));
        }

        public async Task<EquipmentResource> CreateEquipmentAsync(EquipmentResource equipmentResource)
        {
            var equipment = new Equipment
            {
                Name = equipmentResource.Name,
                Quantity = equipmentResource.Quantity,
                Category = equipmentResource.Category,
                LastScanDate = equipmentResource.LastScanDate,
                NextScanDate = equipmentResource.NextScanDate
            };

            _context.Equipments.Add(equipment);
            await _context.SaveChangesAsync();

            return MapEquipmentToResource(equipment);
        }

        public async Task UpdateEquipmentAsync(int equipmentId, EquipmentResource equipmentResource)
        {
            var equipment = await _context.Equipments.FindAsync(equipmentId);
            if (equipment == null)
            {
                throw new Exception($"Equipment with ID {equipmentId} not found");
            }

            equipment.Name = equipmentResource.Name;
            equipment.Quantity = equipmentResource.Quantity;
            equipment.Category = equipmentResource.Category;
            equipment.LastScanDate = equipmentResource.LastScanDate;
            equipment.NextScanDate = equipmentResource.NextScanDate;

            await _context.SaveChangesAsync();
        }

        public async Task<bool> DeleteEquipmentAsync(int equipmentId)
        {
            var equipment = await _context.Equipments.FindAsync(equipmentId);
            if (equipment == null)
            {
                return false;
            }

            _context.Equipments.Remove(equipment);
            await _context.SaveChangesAsync();
            return true;
        }

        private EquipmentResource MapEquipmentToResource(Equipment equipment)
        {
            return new EquipmentResource
            {
                EquipmentId = equipment.EquipmentId,
                Name = equipment.Name,
                Quantity = equipment.Quantity,
                Category = equipment.Category,
                LastScanDate = equipment.LastScanDate,
                NextScanDate = equipment.NextScanDate
            };
        }
    }
}
