using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class MedicalRecord
    {
        public int RecordId { get; set; }
        public int? PetId { get; set; }
        public string? Description { get; set; }
        public string? Service { get; set; }
        public byte[]? TestResults { get; set; }
        public DateTime? Date { get; set; }
        public string? Status { get; set; }

        public virtual Pet? Pet { get; set; }
    }
}
