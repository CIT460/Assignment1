using System;
using System.Collections.Generic;
using System.Text;

namespace Collector.Entity.Tables
{
    public class City
    {
        public int CityId { get; set; }
        public string CityUrl { get; set; }
        public string CityName { get; set; }
        public string StateName { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public long Population { get; set; }
        public double NeverMarriedRate { get; set; }
        public double NowMarriedRate { get; set; }
        public double SeparetedRate { get; set; }
        public double WidowedRate { get; set; }
        public double DivorceRate { get; set; }
        public int NaturalDisasters { get; set; }
        public long Police { get; set; }
        public int Hopsital { get; set; }
        public long MedianIncome { get; set; }
        public double CrimeIndex { get; set; }

        public double HappyScore { get; set; }
        public double SadScore { get; set; }


        public List<TourTrap> TouristTraps { get; set; } = new List<TourTrap>();
    }
}
