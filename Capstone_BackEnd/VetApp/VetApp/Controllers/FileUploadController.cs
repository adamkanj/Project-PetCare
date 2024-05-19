
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Threading.Tasks;

namespace VetApp.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FileUploadController : ControllerBase
    {
        private readonly string _filesFolder = "Files"; // Path to the folder where files will be saved

        [HttpPost("upload")]
        public async Task<IActionResult> UploadFile(IFormFile file)
        {
            if (file == null || file.Length == 0)
            {
                return BadRequest("File not selected or empty.");
            }

            try
            {
                // Ensure the Files folder exists
                if (!Directory.Exists(_filesFolder))
                {
                    Directory.CreateDirectory(_filesFolder);
                }

                // Generate a unique file name
                string fileName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
                string filePath = Path.Combine(_filesFolder, fileName);

                // Save the file to the server
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await file.CopyToAsync(stream);
                }

                // Return the server-side path of the saved file
                return Ok(filePath);
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, $"Error uploading file: {ex.Message}");
            }
        }
    }
}
