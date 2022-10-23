﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using Newtonsoft.Json.Linq;
using WorldCupOnline_API.Models;

namespace WorldCupOnline_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PhaseController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        public PhaseController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public JsonResult GetPhases()
        {
            string query = @"stored procedure";

            DataTable table = new DataTable();
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
            SqlDataReader myReader;
            using (SqlConnection myCon = new SqlConnection(sqlDataSource))
            {
                myCon.Open();
                using (SqlCommand myCommand = new SqlCommand(query, myCon))
                {
                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);
                    myReader.Close();
                    myCon.Close();
                }
            }

            TextInfo ti = CultureInfo.CurrentCulture.TextInfo;
            foreach (DataColumn column in table.Columns)
            {
                column.ColumnName = ti.ToLower(column.ColumnName);
            }

            return new JsonResult(table);
        }

        [HttpGet("{id}")]
        public string GetPhase(int id)
        {
            string lbl_id;
            string lbl_name;
            string lbl_tournamentid;

            //SQL Query
            string query = @"
                            stored procedure";
            DataTable table = new DataTable();//Created table to store data
            string sqlDataSource = _configuration.GetConnectionString("WorldCupOnline");
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
                lbl_tournamentid = row["tournamentID"].ToString();

                var data = new JObject(new JProperty("id", lbl_id), new JProperty("name", lbl_name),
                   new JProperty("tournamentID", float.Parse(lbl_tournamentid)));

                return data.ToString();
            }
            else
            {
                var data = new JObject(new JProperty("Existe", "no"));
                return data.ToString();
            }
        }

        [HttpPost]
        public JsonResult PostPhase(Phase phase)
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
                myCommand.Parameters.AddWithValue("@id", phase.id);
                myCommand.Parameters.AddWithValue("@name", phase.name);
                myCommand.Parameters.AddWithValue("@tournamentID", phase.tournamentID);

                myReader = myCommand.ExecuteReader();
                table.Load(myReader);
                myReader.Close();
                myCon.Close();//Closed connection

            }

            return new JsonResult(table); //Returns table with info
        }

        [HttpPut]
        public ActionResult PutPhase(Phase phase)
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
                    myCommand.Parameters.AddWithValue("@id", phase.id);
                    myCommand.Parameters.AddWithValue("@name", phase.name);
                    myCommand.Parameters.AddWithValue("@tournamentID", phase.tournamentID);

                    myReader = myCommand.ExecuteReader();
                    table.Load(myReader);
                    myReader.Close();
                    myCon.Close();//Closed connection
                }
            }
            return Ok(); //Returns acceptance
        }

        [HttpDelete("{id}")]
        public ActionResult DeletePhase(int id)
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