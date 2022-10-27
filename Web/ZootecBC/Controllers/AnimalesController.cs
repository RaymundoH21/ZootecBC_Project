using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ZootecBC.Models;
using ZootecBC.Repositories;

namespace ZootecBC.Controllers
{
    public class AnimalesController : ControllerBase
    {
        private readonly animalesrepository Animalesrepository;
        public AnimalesController(animalesrepository _Animalesrepository) { 
         Animalesrepository = _Animalesrepository;
        }
        [HttpGet("{id}")]
        public IActionResult GetAnimales(string id) {
            animalesfirestore animales = Animalesrepository.Get(new Models.animalesfirestore()
            {
                Id = id
            });
            if (animales==null)
            {
                return NotFound();
            }
            return Ok(animales);
        }
    }
}
