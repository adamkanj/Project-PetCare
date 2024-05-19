using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using VetApp.Resources;

namespace VetApp.Models
{
    public partial class VetAppContext : DbContext
    {
        public VetAppContext()
        {
        }

        public VetAppContext(DbContextOptions<VetAppContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Appointment> Appointments { get; set; } = null!;
        public virtual DbSet<Cart> Carts { get; set; } = null!;
        public virtual DbSet<Equipment> Equipments { get; set; } = null!;
        public virtual DbSet<MedicalRecord> MedicalRecords { get; set; } = null!;
        public virtual DbSet<Notification> Notifications { get; set; } = null!;
        public virtual DbSet<Order> Orders { get; set; } = null!;
        public virtual DbSet<OrderDetail> OrderDetails { get; set; } = null!;
        public virtual DbSet<Pet> Pets { get; set; } = null!;
        public virtual DbSet<PetOwner> PetOwners { get; set; } = null!;
        public virtual DbSet<Product> Products { get; set; } = null!;
        public virtual DbSet<ProductReview> ProductReviews { get; set; } = null!;
        public virtual DbSet<Review> Reviews { get; set; } = null!;
        public virtual DbSet<User> Users { get; set; } = null!;
        public virtual DbSet<RegistrationAttempt> RegistrationAttempts { get; set; } = null!;

        public virtual DbSet<Vaccination> Vaccinations { get; set; } = null!;
        public virtual DbSet<Veterinarian> Veterinarians { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Server= LAPTOP-M07KKVAV\\SQLEXPRESS;Database=VetApp;Trusted_Connection=True;TrustServerCertificate=True");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Appointment>(entity =>
            {
                entity.ToTable("Appointment");

                entity.Property(e => e.AppointmentId).HasColumnName("AppointmentID");

                entity.Property(e => e.AppointmentDate);

                entity.Property(e => e.Category).HasMaxLength(50);

                entity.Property(e => e.OwnerId).HasColumnName("OwnerID");

                entity.Property(e => e.Status).HasMaxLength(20);

                entity.Property(e => e.VetId).HasColumnName("VetID");

                entity.Property(e => e.PetId).HasColumnName("PetId");

                entity.Property(e => e.Description).HasColumnName("Description");

                entity.HasOne(d => d.Owner)
                    .WithMany(p => p.Appointments)
                    .HasForeignKey(d => d.OwnerId)
                    .HasConstraintName("FK__Appointme__Owner__4222D4EF");

                entity.HasOne(d => d.Vet)
                    .WithMany(p => p.Appointments)
                    .HasForeignKey(d => d.VetId)
                    .HasConstraintName("FK__Appointme__VetID__4316F928");

                entity.HasOne(d => d.Pet)
                    .WithMany(p => p.Appointments)
                    .HasForeignKey(d => d.PetId)
                    .HasConstraintName("FK__Notificat__PetID__52593CB8");

            });

            modelBuilder.Entity<Cart>(entity =>
            {
                entity.ToTable("Cart");

                entity.Property(e => e.CartId).HasColumnName("CartID");

                entity.Property(e => e.OwnerId).HasColumnName("OwnerID");

                entity.Property(e => e.ProductId).HasColumnName("ProductID");

                entity.Property(e => e.Timestamp)
                    .IsRowVersion()
                    .IsConcurrencyToken();

                entity.HasOne(d => d.Owner)
                    .WithMany(p => p.Carts)
                    .HasForeignKey(d => d.OwnerId)
                    .HasConstraintName("FK__Cart__OwnerID__5AEE82B9");

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.Carts)
                    .HasForeignKey(d => d.ProductId)
                    .HasConstraintName("FK__Cart__ProductID__5BE2A6F2");
            });

            modelBuilder.Entity<Equipment>(entity =>
            {
                entity.ToTable("Equipment");  // Ensuring the table name is exactly as in the database

                entity.Property(e => e.EquipmentId).HasColumnName("EquipmentID");
                entity.Property(e => e.Category).HasMaxLength(100);
                entity.Property(e => e.LastScanDate)
                      .HasColumnType("date")
                      .HasColumnName("Last_Scan_Date");
                entity.Property(e => e.Name).HasMaxLength(100);
                entity.Property(e => e.NextScanDate)
                      .HasColumnType("date")
                      .HasColumnName("Next_Scan_Date");
            });


            modelBuilder.Entity<MedicalRecord>(entity =>
            {
                entity.HasKey(e => e.RecordId)
                    .HasName("PK__Medical___FBDF78C9440B3734");

                entity.ToTable("Medical_Record");

                entity.Property(e => e.RecordId).HasColumnName("RecordID");

                entity.Property(e => e.Date).HasColumnType("date");

                entity.Property(e => e.PetId).HasColumnName("PetID");

                entity.Property(e => e.Service).HasMaxLength(50);

                entity.Property(e => e.Status).HasMaxLength(60);

                entity.HasOne(d => d.Pet)
                    .WithMany(p => p.MedicalRecords)
                    .HasForeignKey(d => d.PetId)
                    .HasConstraintName("FK__Medical_R__PetID__49C3F6B7");
            });

            modelBuilder.Entity<Notification>(entity =>
            {
                entity.ToTable("Notification");

                entity.Property(e => e.NotificationId).HasColumnName("NotificationID");

                entity.Property(e => e.Content).HasMaxLength(250);

                entity.Property(e => e.Timestamp).HasColumnType("Timestamp");

                entity.Property(e => e.Title).HasMaxLength(50);

                entity.Property(e => e.UserId).HasColumnName("UserID");


                entity.HasOne(d => d.User)
                    .WithMany(p => p.Notifications)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("FK__Notificat__UserI__5165187F");
            });

            modelBuilder.Entity<Order>(entity =>
            {
                entity.ToTable("Order");

                entity.Property(e => e.OrderId).HasColumnName("OrderID");

                entity.Property(e => e.Address).HasMaxLength(150);

                entity.Property(e => e.OrderDate)
                    .HasColumnType("date")
                    .HasColumnName("Order_Date");

                entity.Property(e => e.OwnerId).HasColumnName("OwnerID");

                entity.Property(e => e.PaymentMethod)
                    .HasMaxLength(100)
                    .HasColumnName("Payment_Method");

                entity.Property(e => e.Status).HasMaxLength(50);

                entity.Property(e => e.TotalAmount).HasColumnName("Total_amount");

                entity.HasOne(d => d.Owner)
                    .WithMany(p => p.Orders)
                    .HasForeignKey(d => d.OwnerId)
                    .HasConstraintName("FK__Order__OwnerID__5EBF139D");
            });

            modelBuilder.Entity<OrderDetail>(entity =>
            {
                entity.HasKey(e => e.OrderDetailsId)
                    .HasName("PK__Order_De__F6868F72AB7321AD");

                entity.ToTable("Order_Details");

                entity.Property(e => e.OrderDetailsId).HasColumnName("Order_Details_ID");

                entity.Property(e => e.OrderId).HasColumnName("OrderID");

                entity.Property(e => e.PriceUnit).HasColumnName("Price_Unit");

                entity.Property(e => e.ProductId).HasColumnName("ProductID");

                entity.HasOne(d => d.Order)
                    .WithMany(p => p.OrderDetails)
                    .HasForeignKey(d => d.OrderId)
                    .HasConstraintName("FK__Order_Det__Order__619B8048");

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.OrderDetails)
                    .HasForeignKey(d => d.ProductId)
                    .HasConstraintName("FK__Order_Det__Produ__628FA481");
            });

            modelBuilder.Entity<Pet>(entity =>
            {
                entity.ToTable("Pet");

                entity.Property(e => e.PetId).HasColumnName("PetID");

                entity.Property(e => e.Breed).HasMaxLength(100);

                entity.Property(e => e.Dob)
                    .HasColumnType("date")
                    .HasColumnName("DOB");

                entity.Property(e => e.Gender).HasMaxLength(20);

                entity.Property(e => e.Name).HasMaxLength(70);

                entity.Property(e => e.OwnerId).HasColumnName("OwnerID");

                entity.Property(e => e.Species).HasMaxLength(100);

                entity.HasOne(d => d.Owner)
                    .WithMany(p => p.Pets)
                    .HasForeignKey(d => d.OwnerId)
                    .HasConstraintName("FK__Pet__OwnerID__3F466844");
            });

            modelBuilder.Entity<PetOwner>(entity =>
            {
                entity.HasKey(e => e.OwnerId)
                    .HasName("PK__Pet_Owne__81938598392E491B");

                entity.ToTable("Pet_Owner");

                entity.Property(e => e.OwnerId).HasColumnName("OwnerID");

                entity.Property(e => e.Address).HasMaxLength(150);

                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.PetOwners)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("FK__Pet_Owner__UserI__3C69FB99");
            });

            modelBuilder.Entity<Product>(entity =>
            {
                entity.ToTable("Product");

                entity.Property(e => e.ProductId).HasColumnName("ProductID");

                entity.Property(e => e.Category).HasMaxLength(50);

                entity.Property(e => e.Name).HasMaxLength(50);

                entity.Property(e => e.PetGenre)
                    .HasMaxLength(50)
                    .HasColumnName("Pet_Genre");
            });

            modelBuilder.Entity<ProductReview>(entity =>
            {
                entity.ToTable("Product_Review");

                entity.Property(e => e.ProductReviewId).HasColumnName("Product_Review_ID");

                entity.Property(e => e.Date).HasColumnType("date");

                entity.Property(e => e.OwnerId).HasColumnName("OwnerID");

                entity.Property(e => e.ProductId).HasColumnName("ProductID");

                entity.HasOne(d => d.Owner)
                    .WithMany(p => p.ProductReviews)
                    .HasForeignKey(d => d.OwnerId)
                    .HasConstraintName("FK__Product_R__Owner__571DF1D5");

                entity.HasOne(d => d.Product)
                    .WithMany(p => p.ProductReviews)
                    .HasForeignKey(d => d.ProductId)
                    .HasConstraintName("FK__Product_R__Produ__5812160E");
            });

            modelBuilder.Entity<Review>(entity =>
            {
                entity.ToTable("Review");

                entity.Property(e => e.ReviewId).HasColumnName("ReviewID");

                entity.Property(e => e.Date).HasColumnType("date");

                entity.Property(e => e.OwnerId).HasColumnName("OwnerID");

                entity.Property(e => e.VetId).HasColumnName("VetID");

                entity.HasOne(d => d.Owner)
                    .WithMany(p => p.Reviews)
                    .HasForeignKey(d => d.OwnerId)
                    .HasConstraintName("FK__Review__OwnerID__45F365D3");

                entity.HasOne(d => d.Vet)
                    .WithMany(p => p.Reviews)
                    .HasForeignKey(d => d.VetId)
                    .HasConstraintName("FK__Review__VetID__46E78A0C");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("User");

                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.Property(e => e.Dob)
                    .HasMaxLength(40)
                    .HasColumnName("DOB");

                entity.Property(e => e.Email).HasMaxLength(256);

                entity.Property(e => e.Fn)
                    .HasMaxLength(40)
                    .HasColumnName("FN");

                entity.Property(e => e.Gender).HasMaxLength(10);

                entity.Property(e => e.Ln)
                    .HasMaxLength(40)
                    .HasColumnName("LN");

                entity.Property(e => e.Role).HasMaxLength(20);

                entity.Property(e => e.Username).HasMaxLength(40);
            });


            modelBuilder.Entity<RegistrationAttempt>(entity =>
            {
                entity.ToTable("RegistrationAttempt");

                entity.Property(e => e.Id).HasColumnName("Id");

                entity.Property(e => e.Username).HasMaxLength(40);

                entity.Property(e => e.Email).HasMaxLength(256);

                entity.Property(e => e.Fn)
                    .HasMaxLength(40)
                    .HasColumnName("FN");

                entity.Property(e => e.Ln)
                    .HasMaxLength(40)
                    .HasColumnName("LN");

                entity.Property(e => e.Dob)
                   .HasMaxLength(40)
                   .HasColumnName("Dob");

                entity.Property(e => e.Gender).HasMaxLength(10).HasColumnName("Gender");

                entity.Property(e => e.Address)
                    .HasMaxLength(150)
                    .HasColumnName("Address");

                entity.Property(e => e.VerificationCode)
                    .HasMaxLength(6)
                    .HasColumnName("VerificationCode");

                entity.Property(e => e.RegistrationKey)
                    .HasMaxLength(36)
                    .HasColumnName("RegistrationKey");

                entity.Property(e => e.IsVerified)
                    .HasConversion(
                        v => v ? (byte)1 : (byte)0,  // Convert boolean to byte when saving to the database
                        v => v == (byte)1            // Convert byte to boolean when reading from the database
                    )
                    .HasColumnName("IsVerified")
                    .IsRequired();
            });

            modelBuilder.Entity<Vaccination>(entity =>
            {
                entity.ToTable("Vaccination");

                entity.Property(e => e.VaccinationId).HasColumnName("VaccinationID");

                entity.Property(e => e.DateAdministered)
                    .HasColumnType("date")
                    .HasColumnName("Date_Administered");

                entity.Property(e => e.NextDueDate)
                    .HasColumnType("date")
                    .HasColumnName("Next_Due_Date");

                entity.Property(e => e.PetId).HasColumnName("PetID");

                entity.Property(e => e.Status).HasMaxLength(50);

                entity.Property(e => e.VaccineName)
                    .HasMaxLength(100)
                    .HasColumnName("Vaccine_Name");

                entity.HasOne(d => d.Pet)
                    .WithMany(p => p.Vaccinations)
                    .HasForeignKey(d => d.PetId)
                    .HasConstraintName("FK__Vaccinati__PetID__4CA06362");
            });

            modelBuilder.Entity<Veterinarian>(entity =>
            {
                entity.HasKey(e => e.VetId)
                    .HasName("PK__Veterina__2556B80E30A9CB89");

                entity.ToTable("Veterinarian");

                entity.Property(e => e.VetId).HasColumnName("VetID");

                entity.Property(e => e.Specialty).HasMaxLength(100);

                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.Property(e => e.WorkSchedule).HasColumnName("Work_Schedule");

                entity.Property(e => e.YearsExperience).HasColumnName("Years_Experience");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.Veterinarians)
                    .HasForeignKey(d => d.UserId)
                    .HasConstraintName("FK__Veterinar__UserI__398D8EEE");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
