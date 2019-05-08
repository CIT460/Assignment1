using Collector.Entity.Tables;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Text;

namespace Collector.Entity
{
    public class CityContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite("Data Source=citydata.db");
        }

        public DbSet<City> Cities { get; set; }
        public DbSet<TourTrap> TourTraps { get; set; }

    }
}
