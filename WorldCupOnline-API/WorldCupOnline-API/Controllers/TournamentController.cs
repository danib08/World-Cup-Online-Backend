﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using WorldCupOnline_API.Models;

namespace WorldCupOnline_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TournamentController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        /// <summary>
        /// Established configuration for controller to get connection
        /// </summary>
        /// <param name="configuration"></param>
        public TournamentController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        /// <summary>
        /// Method to get all created tournaments
        /// </summary>
        /// <returns>JSONResult with all tournaments</returns>
        [HttpGet]
        public JsonResult GetTournaments()
        {
            string query = @"exec proc_tournament '','','','','',0,'Select WebApp'"; ///sql query

            DataTable table = new DataTable(); ///Create datatable
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");  ///Establish connection
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open(); ///Open connection
                using (SqlCommand myCommand = new SqlCommand(query, myCon))
                {
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader); ///Data is loaded into table
                    myReader.Close();
                    myCon.Close(); ///Closed connection
                }
            }

            TextInfo ti = CultureInfo.CurrentCulture.TextInfo;
            foreach(DataColumn column in table.Columns)
            {
                column.ColumnName = ti.ToLower(column.ColumnName); ///Make all lowercase to avoid conflicts with communication
            }

            return new JsonResult(table); ///Return JSON Of the data table
        }

        
        /// <summary>
        /// Method to get one Tournament by its id
        /// </summary>
        /// <param name="id"></param>
        /// <returns>Json of the required tournaments</returns>
        [HttpGet("{id}")]
        public string GetTournament(string id)
        {
            ///Created labels
            string lbl_id;
            string lbl_name;
            string lbl_startdate;
            string lbl_enddate;
            string lbl_description;
            string lbl_type;


            ///SQL Query
            string query = @"
                            exec proc_tournament @id,'','','','',0,'Select One WebApp'";
            DataTable table = new DataTable();///Created table to store data
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))///Connection created
            {
                myCon.Open();///Open connection
                using (SqlCommand myCommand = new SqlCommand(query, myCon))///Command with query and connection
                {
                    ///Added parameters
                    myCommand.Parameters.AddWithValue("@id", id);
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader); ///Load data to table
                    myReader.Close();
                    myCon.Close(); ///Close connection
                }
            }

            ///Verify if table is empty
            if (table.Rows.Count > 0)
            {

                DataRow row = table.Rows[0];

                ///Manipulation of every row of datatable and parse them to string
                lbl_id = row["id"].ToString();
                lbl_name = row["name"].ToString();
                lbl_startdate = row["startDate"].ToString();
                lbl_enddate = row["endDate"].ToString();
                lbl_description= row["description"].ToString();
                lbl_type = row["type"].ToString();


                var data = new JObject(new JProperty("id", lbl_id), new JProperty("name", lbl_name),
                   new JProperty("startDate", DateTime.Parse(lbl_startdate)), new JProperty("endDate", DateTime.Parse(lbl_enddate)),
                   new JProperty("description", lbl_description), new JProperty("type", lbl_type));

                return data.ToString(); ///Return created JSON
            }
            else
            {
                var data = new JObject(new JProperty("Existe", "no"));
                return data.ToString(); ///Return message if table is empty
            }
        }

        /// <summary>
        /// Method to create tournament
        /// </summary>
        /// <param name="tournament"></param>
        /// <returns>JSON of the tournament created</returns>
        [HttpPost]
        public JsonResult PostTournament(TournamentCreator creator)
        {
            

            ///SQL Query
            string query = @"
                             exec proc_tournament @id,@name,@startdate,@enddate,@description,@typeid,'Insert'
                            ";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))///Connection stablished
            {
                myCon.Open(); ///Opened connection
                SqlCommand myCommand = new SqlCommand(query, myCon);

                ///Parameters added with values
                myCommand.Parameters.AddWithValue("@id", creator.id);
                myCommand.Parameters.AddWithValue("@name", creator.name);
                myCommand.Parameters.AddWithValue("@startdate", creator.startdate);
                myCommand.Parameters.AddWithValue("@enddate", creator.enddate);
                myCommand.Parameters.AddWithValue("@description", creator.description);
                myCommand.Parameters.AddWithValue("@typeid", creator.typeid);

                myReader = myCommand.ExecuteReader();
                table.Load(myReader);
                myReader.Close();
                myCon.Close();///Closed connection
            }

            foreach (string id in creator.teamsIds)
            {
                Team_In_Tournament team_In_Tournament = new()
                {
                    teamid = id,
                    tournamentid = creator.id
                };
                PostTeam_In_Tournament(team_In_Tournament);
            }

            foreach (string phaseName in creator.phases)
            {
                Phase phase = new()
                {
                    name = phaseName,
                    tournamentID = creator.id
                };
                PostPhase(phase);
            }


            return new JsonResult(table); ///Returns table with info

        }

        /// <summary>
        /// Method to update a tournament
        /// </summary>
        /// <param name="tournament"></param>
        /// <returns>Action result of the query</returns>
        [HttpPut]
        public ActionResult PutTournament(Tournament tournament)
        {
            ///SQL Query
            string query = @"
                             exec proc_tournament @id,@name,@startdate,@enddate,@description,@typeid,'Update'
                            ";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))///Connection started
            {
                myCon.Open(); ///Connection closed
                using (SqlCommand myCommand = new SqlCommand(query, myCon))///Sql command with query and connection
                {
                    ///Added parameters
                    myCommand.Parameters.AddWithValue("@id", tournament.id);
                    myCommand.Parameters.AddWithValue("@name", tournament.name);
                    myCommand.Parameters.AddWithValue("@startdate", tournament.startdate);
                    myCommand.Parameters.AddWithValue("@enddate", tournament.enddate);
                    myCommand.Parameters.AddWithValue("@description", tournament.description);
                    myCommand.Parameters.AddWithValue("@typeid", tournament.typeid);


                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);
                    myReader.Close();
                    myCon.Close();///Closed connection
                }
            }
            return Ok(); ///Returns acceptance
        }

        /// <summary>
        /// Method to delete a tournaments by its id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpDelete("{id}")]
        public ActionResult DeleteTournament(string id)
        {
            ///SQL Query
            string query = @"
                            exec proc_tournament @id,'','','','',0,'Delete'
            ";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))///Connection created
            {
                myCon.Open();///Open connection
                using (SqlCommand myCommand = new SqlCommand(query, myCon)) ///Command with query and connection
                {
                    myCommand.Parameters.AddWithValue("@id", id);
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);
                    myReader.Close();
                    myCon.Close();///Closed connection
                }
            }
            return Ok(); ///Returns acceptance
        }

        [HttpGet("Matches/{id}")]
        public JsonResult GetMatchesByTournament(string id)
        {
            string query = @"exec proc_tournament @id,'','','','',0,'Get Matches By Tourn'"; ///sql query

            DataTable table = new DataTable(); ///Create datatable
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");  ///Establish connection
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open(); ///Open connection
                using (SqlCommand myCommand = new SqlCommand(query, myCon))
                {
                    myCommand.Parameters.AddWithValue("@id", id);
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader); ///Data is loaded into table
                    myReader.Close();
                    myCon.Close(); ///Closed connection
                }
            }

            TextInfo ti = CultureInfo.CurrentCulture.TextInfo;
            foreach (DataColumn column in table.Columns)
            {
                column.ColumnName = ti.ToLower(column.ColumnName); ///Make all lowercase to avoid conflicts with communication
            }

            return new JsonResult(table); ///Return JSON Of the data table
        }

        [HttpGet("Phases/{id}")]
        public JsonResult GetPhasesByTournament(string id)
        {
            string query = @"exec proc_tournament @id,'','','','',0,'Get Phases By Tourn'"; ///sql query

            DataTable table = new DataTable(); ///Create datatable
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");  ///Establish connection
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open(); ///Open connection
                using (SqlCommand myCommand = new SqlCommand(query, myCon))
                {
                    myCommand.Parameters.AddWithValue("@id", id);
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader); ///Data is loaded into table
                    myReader.Close();
                    myCon.Close(); ///Closed connection
                }
            }

            TextInfo ti = CultureInfo.CurrentCulture.TextInfo;
            foreach (DataColumn column in table.Columns)
            {
                column.ColumnName = ti.ToLower(column.ColumnName); ///Make all lowercase to avoid conflicts with communication
            }

            return new JsonResult(table); ///Return JSON Of the data table
        }

        [HttpGet("Teams/{id}")]
        public JsonResult GetTeamsByTournament(string id)
        {
            string query = @"exec proc_tournament @id,'','','','',0,'Get Teams By Tourn'"; ///sql query

            DataTable table = new DataTable(); ///Create datatable
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");  ///Establish connection
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open(); ///Open connection
                using (SqlCommand myCommand = new SqlCommand(query, myCon))
                {
                    myCommand.Parameters.AddWithValue("@id", id);
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader); ///Data is loaded into table
                    myReader.Close();
                    myCon.Close(); ///Closed connection
                }
            }

            TextInfo ti = CultureInfo.CurrentCulture.TextInfo;
            foreach (DataColumn column in table.Columns)
            {
                column.ColumnName = ti.ToLower(column.ColumnName); ///Make all lowercase to avoid conflicts with communication
            }

            return new JsonResult(table); ///Return JSON Of the data table
        }

        [HttpPost("postTeamInTournament")]
        public JsonResult PostTeam_In_Tournament(Team_In_Tournament team_In_Tournament)
        {
            ///SQL Query
            string query = @"
                             exec proc_teamInTournament @teamid,@tournamentid,'Insert'
                            ";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))//Connection stablished
            {
                myCon.Open(); ///Opened connection
                SqlCommand myCommand = new SqlCommand(query, myCon);

                ///Parameters added with values
                myCommand.Parameters.AddWithValue("@teamid", team_In_Tournament.teamid);
                myCommand.Parameters.AddWithValue("@tournamentid", team_In_Tournament.tournamentid);

                myReader = myCommand.ExecuteReader();
                table.Load(myReader);
                myReader.Close();
                myCon.Close();///Closed connection
            }

            return new JsonResult(table); ///Returns table with info

        }

        [HttpPost("postPhase")]
        public JsonResult PostPhase(Phase phase)
        {
            ///SQL Query
            string query = @"
                             exec proc_phase @id,@name,@tournamentid,'Insert'
                            ";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))///Connection stablished
            {
                myCon.Open(); ///Opened connection
                SqlCommand myCommand = new SqlCommand(query, myCon);

                ///Parameters added with values
                myCommand.Parameters.AddWithValue("@id", phase.id);
                myCommand.Parameters.AddWithValue("@name", phase.name);
                myCommand.Parameters.AddWithValue("@tournamentid", phase.tournamentID);

                myReader = myCommand.ExecuteReader();
                table.Load(myReader);
                myReader.Close();
                myCon.Close();///Closed connection

            }

            return new JsonResult(table); ///Returns table with info
        }
    }
}
