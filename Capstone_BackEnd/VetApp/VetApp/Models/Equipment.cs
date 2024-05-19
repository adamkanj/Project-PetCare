using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class Equipment
    {
        public int EquipmentId { get; set; }
        public string? Name { get; set; }
        public int? Quantity { get; set; }
        public string? Category { get; set; }
        public DateTime? LastScanDate { get; set; }
        public DateTime? NextScanDate { get; set; }
    }
}
