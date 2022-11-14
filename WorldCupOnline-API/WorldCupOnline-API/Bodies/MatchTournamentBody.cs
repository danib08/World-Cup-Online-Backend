﻿namespace WorldCupOnline_API.Bodies
{
    public class MatchTournamentBody
    {
        public int id { get; set; }
        public string name { get; set; }
        public DateTime startdate { get; set; }
        public TimeSpan starttime { get; set; }
        public string location { get; set; }
        public string state { get; set; }
        public string score { get; set; }
    }
}
