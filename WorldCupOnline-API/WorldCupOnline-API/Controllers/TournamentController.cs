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

        public TournamentController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public JsonResult GetTournaments()
        {
            string query = @"select * from dbo.Tournament";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open();
                using(SqlCommand myCommand = new SqlCommand(query, myCon))
                {
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);
                    myReader.Close();
                    myCon.Close();
                }
            }

            TextInfo ti = CultureInfo.CurrentCulture.TextInfo;
            foreach(DataColumn column in table.Columns)
            {
                column.ColumnName = ti.ToLower(column.ColumnName);
            }

            return new JsonResult(table);
        }

        [HttpGet("{id}")]
        public string GetTournament(string id)
        {

            string lbl_id;
            string lbl_name;
            string lbl_startDate;
            string lbl_endDate;
            string lbl_local;
            string lbl_description;


            //SQL Query
            string query = @"
                            stored procedure";
            DataTable table = new DataTable();//Created table to store data
            string sqlDataSource = _configuration.GetConnectionString("StraviaTec");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))//Connection created
            {
                myCon.Open();//Open connection
                using (SqlCommand myCommand = new SqlCommand(query, myCon))//Command with query and connection
                {
                    //Added parameters
                    myCommand.Parameters.AddWithValue("@id", id);
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader); //Load data to table
                    myReader.Close();
                    myCon.Close(); //Close connection
                }
            }

            if (table.Rows.Count > 0)
            {

                DataRow row = table.Rows[0];

                lbl_id = row["id"].ToString();
                lbl_name = row["name"].ToString();
                lbl_startDate = row["startDate"].ToString();
                lbl_endDate = row["endDate"].ToString();
                lbl_local = row["privacy"].ToString();
                lbl_description= row["kilometers"].ToString();


                var data = new JObject(new JProperty("id", lbl_id), new JProperty("name", lbl_name),
                   new JProperty("startDate", DateTime.Parse(lbl_startDate)), new JProperty("endDate", DateTime.Parse(lbl_endDate)), new JProperty("privacy", lbl_local),
                   new JProperty("kilometers", float.Parse(lbl_description)));

                return data.ToString();
            }
            else
            {
                var data = new JObject(new JProperty("Existe", "no"));
                return data.ToString();
            }

        }


        [HttpPost]
        public JsonResult PostTournament(Tournament tournament)
        {
            

            //SQL Query
            string query = @"
                             stored procedure
                            ";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))//Connection stablished
            {
                myCon.Open(); //Opened connection
                SqlCommand myCommand = new SqlCommand(query, myCon);

                //Parameters added with values
                myCommand.Parameters.AddWithValue("@id", tournament.id);
                myCommand.Parameters.AddWithValue("@name", tournament.name);
                myCommand.Parameters.AddWithValue("@startdate", tournament.startDate);
                myCommand.Parameters.AddWithValue("@enddate", tournament.endDate);
                myCommand.Parameters.AddWithValue("@local", tournament.local);
                myCommand.Parameters.AddWithValue("@description", tournament.description);


                myReader = myCommand.ExecuteReader();
                table.Load(myReader);
                myReader.Close();
                myCon.Close();//Closed connection

            }

            return new JsonResult(table); //Returns table with info

        }


        [HttpPut]
        public ActionResult PutTournament(Tournament tournament)
        {
            //SQL Query
            string query = @"
                             stored procedures
                            ";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))//Connection started
            {
                myCon.Open(); //Connection closed
                using (SqlCommand myCommand = new SqlCommand(query, myCon))//Sql command with query and connection
                {
                    //Added parameters
                    myCommand.Parameters.AddWithValue("@id", tournament.id);
                    myCommand.Parameters.AddWithValue("@name", tournament.name);
                    myCommand.Parameters.AddWithValue("@startdate", tournament.startDate);
                    myCommand.Parameters.AddWithValue("@enddate", tournament.endDate);
                    myCommand.Parameters.AddWithValue("@local", tournament.local);
                    myCommand.Parameters.AddWithValue("@description", tournament.description);


                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);
                    myReader.Close();
                    myCon.Close();//Closed connection
                }
            }
            return Ok(); //Returns acceptance
        }

        [HttpDelete("{id}")]
        public ActionResult DeleteTournament(string id)
        {
            //SQL Query
            string query = @"
                            stored procedure
            ";
            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))//Connection created
            {
                myCon.Open();//Open connection
                using (SqlCommand myCommand = new SqlCommand(query, myCon)) //Command with query and connection
                {
                    myCommand.Parameters.AddWithValue("@id", id);
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);
                    myReader.Close();
                    myCon.Close();//Closed connection
                }
            }
            return Ok(); //Returns acceptance
        }

    }
}