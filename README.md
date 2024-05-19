# Project-PetCare

Capstone Project for Lebanese American University (LAU) about a Vet clinic App called PetCare.

## Project Overview

PetCare is a comprehensive veterinary clinic management application developed as part of a capstone project at the Lebanese American University (LAU) under the supervision of Dr. Nadine Abbas. The project was collaboratively developed by Ahmad Malak and Adam Kanj. The primary goal of PetCare is to streamline veterinary clinic operations, enabling efficient management of appointments, products, equipment, veterinarians, and pet owner interactions.

## Features

- **Appointment Management:** Schedule and manage veterinary appointments.
- **Veterinarian Management:** Manage veterinarian profiles and availability.
- **Product Management:** Track and manage veterinary products.
- **Equipment Management:** Maintain and manage clinic equipment.
- **Notifications:** Stay updated with the latest clinic notifications.
- **Profile Management:** Manage user profiles for veterinarians and pet owners.

## Repository Structure

The repository is organized as follows:

- **Capstone_BackEnd/VetApp/**: Contains the backend code for the VetApp, built with ASP.NET Web API.
- **Capstone_Database/projectdb/**: Database files and scripts used in the project.
- **Capstone_FrontEnd/Capstone/**: Frontend code for the application, developed using Flutter and Dart.
- **assets/**: Contains various assets used in the project such as images and icons.
- **Capstone Report.docx**: Detailed project report in Word format.
- **Capstone Report.pdf**: Detailed project report in PDF format.
- **ER Diagram.jpg**: Entity-Relationship Diagram of the project database.
- **PetCare.pptx**: Presentation slides for the project.
- **assets.zip**: Compressed folder containing all project assets.

## Getting Started

### Prerequisites

- **Backend**: ASP.NET Core
- **Frontend**: Flutter SDK
- **Database**: SQL Server
- **IDE**: Visual Studio for backend, Visual Studio Code or Android Studio for frontend

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/adamkanj/Project-PetCare.git
   ```

2. **Navigate to Backend Directory:**

   ```bash
   cd Capstone_BackEnd/VetApp
   ```

   - Open the project in Visual Studio.
   - Restore NuGet packages.
   - Update database connection string in `appsettings.json`.
   - Run the project.

3. **Navigate to Frontend Directory:**

   ```bash
   cd Capstone_FrontEnd/Capstone
   ```

   - Open the project in Visual Studio Code or Android Studio.
   - Run `flutter pub get` to install dependencies.
   - Ensure a device is connected or an emulator is running.
   - Run the project using `flutter run`.

### Usage

- **Admin Login**: Use the admin credentials provided in the project documentation to log in and access admin functionalities.
- **Manage Veterinarians**: Navigate to the Veterinarian Management section to add, update, or delete veterinarian profiles.
- **Schedule Appointments**: Use the Appointment Management section to schedule new appointments.
- **Manage Products and Equipment**: Track and manage products and equipment within the clinic.
- **Profile and Notifications**: Access and update user profiles and view clinic notifications.

## References

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [ASP.NET Core Documentation](https://docs.microsoft.com/en-us/aspnet/core/?view=aspnetcore-5.0)
- [Entity Framework Core](https://docs.microsoft.com/en-us/ef/core/)
- [SQL Server](https://docs.microsoft.com/en-us/sql/sql-server/?view=sql-server-ver15)

## Contributors

- Ahmad Malak
- Adam Kanj
