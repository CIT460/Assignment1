using System;
using System.Collections.Generic;
using System.Text;

namespace Collector.Entity.Tables
{
    public class TourTrap
    {
        public int TourTrapId { get; set; }
        public string Title { get; set; }

        public City City { get; set; }
        public int CityId { get; set; }
    }
}
