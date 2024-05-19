using Microsoft.EntityFrameworkCore;
using VetApp.Interfaces;
using VetApp.Models;
using VetApp.PasswordHashing;
using VetApp.Repositories;
using AutoMapper;
using Microsoft.AspNetCore.Hosting;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowSpecificOrigin", policy =>
    {
        policy.WithOrigins("*")  
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<VetAppContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(Program));

// Register your service interfaces and their implementations
builder.Services.AddScoped<IAdmin, AdminRepository>(); // Example
builder.Services.AddScoped<IPetOwner, PetOwnerRepository>(); // Example
builder.Services.AddScoped<IVeterinarian, VeterinarianRepository>();
builder.Services.AddScoped<IReview, ReviewRepository>();
builder.Services.AddScoped<IAppointment, AppointmentRepository>();
builder.Services.AddScoped<IPet, PetRepository>();
builder.Services.AddScoped<IProduct, ProductRepository>();
builder.Services.AddScoped<ICart, CartRepository>();
builder.Services.AddScoped<IOrder, OrderRepository>();
builder.Services.AddScoped<IProductReview, ProductReviewRepository>();
builder.Services.AddScoped<IEquipment, EquipmentRepository>();
builder.Services.AddScoped<IMedicalRecord, MedicalRecordRepository>();
builder.Services.AddScoped<IVaccination, VaccinationRepository>();
builder.Services.AddScoped<INotification, NotificationRepository>();

builder.Services.AddScoped<IAuthentication, AuthenticationRepository>();

// Add password hashing service
builder.Services.AddScoped<IPasswordHashingService, PasswordHashingService>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseStaticFiles();

app.UseHttpsRedirection();

app.UseCors("AllowSpecificOrigin");  // Ensure this is placed correctly

app.UseAuthorization();

app.MapControllers();

app.Run();
