using System.Collections.Generic;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IEquipment
    {
        Task<EquipmentResource> GetEquipmentByIdAsync(int equipmentId);
        Task<IEnumerable<EquipmentResource>> GetAllEquipmentAsync();
        Task<EquipmentResource> CreateEquipmentAsync(EquipmentResource equipmentResource);
        Task UpdateEquipmentAsync(int equipmentId, EquipmentResource equipmentResource);
        Task<bool> DeleteEquipmentAsync(int equipmentId);
    }
}
