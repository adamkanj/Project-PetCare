using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using VetApp.Resources;

namespace VetApp.Interfaces
{
    public interface IAuthentication
    {
        Task<string> InitiateSignUpAsync(Usersignup usersignup);
        Task<ActionResult<PetOwnerResource>> VerifyAndCreatePetOwnerAsync(string registrationKey, string verificationCode);
    }
}
