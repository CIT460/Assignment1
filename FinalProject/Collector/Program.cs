using Collector.Entity;
using Collector.Entity.Tables;
using HtmlAgilityPack;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;

namespace Collector
{
    class Program
    {
        static void Main(string[] args)
        {
            int Stored = 0;
            int Errored = 0;
            int Skipped = 0;
            // Get CSV with cities
            TextReader reader = new StreamReader("CityList.csv");

            List<String> Urls = new List<string>();

            // Skip the first header line
            reader.ReadLine();


            while (reader.Peek() >= 0)
            {
                var line = reader.ReadLine().Split(",");
                try
                {
                    var url = line[2];
                    Urls.Add(url);
                }
                catch (Exception err)
                {

                }
            }



            foreach (var url in Urls)
            {
                Console.Title = $"{((double)(Stored + Errored + Skipped) / (double)Urls.Count)*100}% - Record {Stored+Errored+Skipped} of {Urls.Count}";
                try
                {
                    using (var db = new CityContext())
                    {
                        var cityCount = db.Cities
                            .Where(x => x.CityUrl == url)
                            .Count();

                        if (cityCount == 0)
                        {

                            var newCity = ProcessUrl(url);

                            if (newCity != null)
                            {
                                db.Cities.Add(newCity);
                                Console.ForegroundColor = ConsoleColor.Green;
                                Console.WriteLine($"Added '{newCity.CityName}' into the db");
                                Console.ResetColor();
                                db.SaveChanges();
                                Stored++;
                            }
                            else
                            {
                                Errored++;
                            }
                        }
                        else
                        {
                            var cityName = db.Cities.Where(x => x.CityUrl == url).Select(x => x.CityName).FirstOrDefault();
                            Console.ForegroundColor = ConsoleColor.Green;
                            Console.WriteLine($"Skipped '{cityName}'. Already in DB. ");
                            Console.ResetColor();
                            Skipped++;
                        }

                    }
                    Task.Delay(TimeSpan.FromMilliseconds(250));
                }
                catch (Exception err)
                {
                    Console.WriteLine($"Error: '{err.Message}'");
                    Errored++;
                    Console.ResetColor();
                }
            }
            Console.WriteLine($"Stored: {Stored} | Skipped: {Skipped} | Error: {Errored}");
            Console.ReadLine();
        }

        private static City ProcessUrl(string url)
        {
            // From String
            var doc = new HtmlDocument();

            try
            {
                using (var web = new HttpClient())
                {
                    web.DefaultRequestHeaders.UserAgent.ParseAdd("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36");
                    var body = web.GetStringAsync(url).Result;
                    doc.LoadHtml(body);


                    var city = new City();
                    city.CityUrl = url;

                    var mainNode = doc.DocumentNode;

                    var name = mainNode.Descendants("span").Where(x => x.ParentNode.Name == "h1").Where(x => x.ParentNode.HasClass("city")).FirstOrDefault().InnerHtml;
                    // Get City Name
                    city.CityName = name.Split(",")[0];
                    // Get State Name
                    city.StateName = name.Split(",")[1];



                    var locationData = mainNode.Descendants("section")
                        .Where(x => x.HasClass("coordinates"))
                        .FirstOrDefault()
                        .SelectSingleNode("p")
                        .ChildNodes
                        .Select(x => x.InnerText).ToList();
                    // Get Location Data
                    city.Latitude = locationData[1];
                    city.Longitude = locationData[3];


                    var pop = mainNode.Descendants("#text").Where(x => x.ParentNode.Name == "section").Where(x => x.ParentNode.HasClass("city-population")).FirstOrDefault().InnerHtml.Replace(",", "");
                    // Get Population

                    if (pop.Contains("("))
                    {
                        city.Population = long.Parse(pop.Split("(")[0]);
                    }
                    else
                    {
                        city.Population = long.Parse(pop);
                    }


                    var marriageSection = mainNode.Descendants("section").Where(x => x.HasClass("marital-info"))
                        .FirstOrDefault()
                        .SelectSingleNode("ul")
                        .ChildNodes
                        .SelectMany(x => x.ChildNodes).ToList();

                    var never = double.Parse(marriageSection[1].InnerHtml.Replace("%", ""));
                    var now = double.Parse(marriageSection[3].InnerHtml.Replace("%", ""));
                    var sep = double.Parse(marriageSection[5].InnerHtml.Replace("%", ""));
                    var wid = double.Parse(marriageSection[7].InnerHtml.Replace("%", ""));
                    var div = double.Parse(marriageSection[9].InnerHtml.Replace("%", ""));


                    // Get Marriage Data
                    city.NeverMarriedRate = never / 100;
                    city.NowMarriedRate = now / 100;
                    city.SeparetedRate = sep / 100;
                    city.WidowedRate = wid / 100;
                    city.DivorceRate = div / 100;



                    var natDis = mainNode.Descendants("section")
                        .Where(x => x.HasClass("natural-disasters"))
                        .SelectMany(x => x.ChildNodes)
                        .ToList()[2]
                        .InnerHtml
                        .Replace("(", "")
                        .Replace(")", "");
                    // Get Natural Disasters
                    city.NaturalDisasters = int.Parse(natDis);


                    try
                    {
                        // Get Tour Traps
                        var tourData = mainNode.Descendants("section")
                            .Where(x => x.HasClass("article-links"))
                            .FirstOrDefault()
                            .SelectSingleNode("div")
                            .SelectSingleNode("ul")
                            .ChildNodes
                            .Where(x => x.Name == "li")
                            .Select(x => x.InnerText);


                        foreach (var tourTrap in tourData)
                        {
                            city.TouristTraps.Add(new TourTrap()
                            {
                                Title = tourTrap,
                                City = city
                            });
                        }
                    }
                    catch (Exception)
                    {
                        
                    }


                    var policeData = mainNode.Descendants("section")
                        .Where(x => x.HasClass("police"))
                        .FirstOrDefault()
                        .ChildNodes
                        .ToList()
                        [1]
                        .InnerHtml
                        .Split("(")
                        [1]
                        .Replace(",", "");
                    // Get Police Data
                    city.Police = long.Parse(policeData);


                    var hospitalData = mainNode.Descendants("section")
                        .Where(x => x.HasClass("hospitals"))
                        .FirstOrDefault()
                        .SelectSingleNode("ul")
                        .ChildNodes
                        .ToList();

                    // Get Hospital Data
                    city.Hopsital = hospitalData.Count();



                    var incomeData = mainNode.Descendants("section")
                        .Where(x => x.HasClass("median-income"))
                        .FirstOrDefault()
                        .ChildNodes
                        .Where(x => x.Name == "#text")
                        .First()
                        .InnerHtml
                        .Replace("$", "")
                        .Replace(",", "")
                        .Replace(" ","")
                        .Replace("(", "")
                        .Trim();

                    // Get Median Income
                    city.MedianIncome = long.Parse(incomeData);



                    var crimeTable = mainNode.Descendants("table")
                        .Where(x => x.HasClass("crime"))
                        .FirstOrDefault()
                        .SelectSingleNode("tfoot")
                        .SelectSingleNode("tr")
                        .ChildNodes
                        .Where(x=>x.Name == "td")
                        .Last()
                        .InnerText;

                    // Get Crime Index Number
                    city.CrimeIndex = double.Parse(crimeTable);

                    return city;
                }
            }
            catch (Exception err)
            {
                Console.WriteLine($"URL: '{url}' failed");
                Console.WriteLine($"Error: '{err.Message}'");

                return null;
            }

        }
    }
}
