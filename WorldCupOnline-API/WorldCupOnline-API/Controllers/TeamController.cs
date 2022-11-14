﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using Newtonsoft.Json.Linq;
using WorldCupOnline_API.Models;
using WorldCupOnline_API.Data;
using WorldCupOnline_API.Bodies;

namespace WorldCupOnline_API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class TeamController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private TeamData _funct; 

        /// <summary>
        /// Establish configuration for controller to get connection
        /// </summary>
        /// <param name="configuration"></param>
        public TeamController(IConfiguration configuration)
        {
            _configuration = configuration;
            _funct = new TeamData();
        }

        [HttpGet]
        public async Task<ActionResult<List<LabelString>>> Get()
        {
            return await _funct.GetTeams();
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<List<Team>>> GetOne(string id)
        {
            return await _funct.GetOneTeam(id);
        }

        [HttpGet("Type/{type}")]
        public async Task<ActionResult<List<LabelString>>> GetTeamsByType(int type)
        {
            return await _funct.GetTeamsByType(type);
        }

        [HttpPost]
        public async Task Post([FromBody] Team team)
        {
            await _funct.CreateTeam(team);
        }

        [HttpPut("{id}")]
        public async Task Put(string id, [FromBody] Team team)
        {
            await _funct.EditTeam(id, team);
            
        }

        [HttpDelete("{id}")]
        public async Task Delete(string id)
        {
            await _funct.DeleteTeam(id);  
        }
    }
}


