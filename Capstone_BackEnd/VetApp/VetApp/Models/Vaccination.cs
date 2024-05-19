using System;
using System.Collections.Generic;

namespace VetApp.Models
{
    public partial class Vaccination
    {
        public int VaccinationId { get; set; }
        public int PetId { get; set; }
        public string? VaccineName { get; set; }
        public string? Notes { get; set; }
        public DateTime? DateAdministered { get; set; }
        public DateTime? NextDueDate { get; set; }
        public string? Status { get; set; }

        public virtual Pet? Pet { get; set; }
    }
}
