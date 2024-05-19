using VetApp.Models;
using VetApp.Resources;
using AutoMapper;

namespace VetApp.Mapping
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Appointment, AppointmentResource>();
            CreateMap<AppointmentResource, Appointment>();

            CreateMap<Cart, CartResource>();
            CreateMap<CartResource, Cart>();

            CreateMap<Equipment, EquipmentResource>();
            CreateMap<EquipmentResource, Equipment>();

            CreateMap<MedicalRecord, MedicalRecordResource>();
            CreateMap<MedicalRecordResource, MedicalRecord>();

            CreateMap<Notification, NotificationResource>();
            CreateMap<NotificationResource, Notification>();

            CreateMap<Order, OrderResource>();
            CreateMap<OrderResource, Order>();

            CreateMap<OrderDetail, OrderDetailResource>();
            CreateMap<OrderDetailResource, OrderDetail>();

            CreateMap<Pet, PetResource>();
            CreateMap<PetResource, Pet>();

            CreateMap<PetOwner, PetOwnerResource>();
            CreateMap<PetOwnerResource, PetOwner>();

            CreateMap<Product, ProductResource>();
            CreateMap<ProductResource, Product>();

            CreateMap<ProductReview, ProductReviewResource>();
            CreateMap<ProductReviewResource, ProductReview>();

            CreateMap<Review, ReviewResource>();
            CreateMap<ReviewResource, Review>();

            CreateMap<User, UserResource>();
            CreateMap<UserResource, User>();

            CreateMap<Vaccination, VaccinationResource>();
            CreateMap<VaccinationResource, Vaccination>();

            CreateMap<Veterinarian, VeterinarianResource>();
            CreateMap<VeterinarianResource, Veterinarian>();
        }
    }
}
