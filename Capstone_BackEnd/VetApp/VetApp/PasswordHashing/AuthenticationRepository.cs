using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Threading.Tasks;
using VetApp.Interfaces;
using VetApp.Models;
using VetApp.Resources;
using AutoMapper;
using VetApp.PasswordHashing;

namespace VetApp.Repositories
{
    public class AuthenticationRepository : IAuthentication
    {
        private readonly VetAppContext _context;
        private readonly IMapper _mapper;
        private readonly IPasswordHashingService _passwordHashingService;

        public AuthenticationRepository(VetAppContext context, IMapper mapper, IPasswordHashingService passwordHashingService)
        {
            _context = context;
            _mapper = mapper;
            _passwordHashingService = passwordHashingService;
        }

        public async Task<string> InitiateSignUpAsync(Usersignup usersignup)
        {
            var verificationCode = GenerateVerificationCode();
            var registrationKey = Guid.NewGuid().ToString();

            var registrationAttempt = new RegistrationAttempt
            {
                Id = 0,
                Username = usersignup.Username,
                Email = usersignup.Email,
                Password = _passwordHashingService.HashPassword(usersignup.Password),
                Fn = usersignup.Fn,
                Ln = usersignup.Ln,
                Dob = usersignup.Dob,
                Gender = usersignup.Gender,
                Address = usersignup.Address,
                VerificationCode = verificationCode,
                RegistrationKey = registrationKey,
            };

            _context.RegistrationAttempts.Add(registrationAttempt);
            await _context.SaveChangesAsync();

            await SendVerificationEmail(usersignup.Email, verificationCode);

            return registrationKey;
        }

        private string GenerateVerificationCode()
        {
            var random = new Random();
            return random.Next(100000, 999999).ToString(); // Generates a 6-digit code
        }

        private async Task SendVerificationEmail(string email, string verificationCode)
        {
            var subject = "Verify your email";
            var body = $"Your verification code is {verificationCode}. Please use this code to complete your registration process.";

            // Use Gmail SMTP server settings
            var smtpClient = new SmtpClient("smtp.gmail.com")
            {
                Port = 587,
                Credentials = new NetworkCredential("pet.care.capstone@gmail.com", "pet car123"), // Replace with your app-specific password
                EnableSsl = true, // SSL must be enabled for Gmail SMTP on port 587
            };

            var mailMessage = new MailMessage
            {
                From = new MailAddress("pet.care.capstone@gmail.com"),
                Subject = subject,
                Body = body,
                IsBodyHtml = false,
            };
            mailMessage.To.Add(email);

            try
            {
                await smtpClient.SendMailAsync(mailMessage);
            }
            catch (SmtpException ex)
            {
                // Log or handle the SMTP-specific exception
                Console.WriteLine("SMTP Error: " + ex.Message);
                throw;
            }
            catch (Exception ex)
            {
                // Log or handle the general exception
                Console.WriteLine("General Error sending email: " + ex.Message);
                throw;
            }
        }



        public async Task<ActionResult<PetOwnerResource>> VerifyAndCreatePetOwnerAsync(string registrationKey, string verificationCode)
        {
            var attempt = await _context.RegistrationAttempts
                .FirstOrDefaultAsync(a => a.RegistrationKey == registrationKey);

            if (attempt != null && attempt.VerificationCode == verificationCode && !attempt.IsVerified)
            {
                var user = new User
                {
                    Username = attempt.Username,
                    Password = attempt.Password,
                    Email = attempt.Email,
                    Fn = attempt.Fn,
                    Ln = attempt.Ln,
                    Dob = attempt.Dob,
                    Gender = attempt.Gender,
                    Role = "PetOwner"
                };

                var petOwner = new PetOwner
                {
                    User = user,
                    Address = attempt.Address
                };

                _context.PetOwners.Add(petOwner);
                await _context.SaveChangesAsync();

                attempt.IsVerified = true;
                _context.RegistrationAttempts.Update(attempt);
                await _context.SaveChangesAsync();

                return new ActionResult<PetOwnerResource>(_mapper.Map<PetOwnerResource>(petOwner));
            }
            else
            {
                return new BadRequestObjectResult("Invalid verification code or registration key, or the token has already been used.");
            }
        }
    }
}
