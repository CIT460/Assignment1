using Microsoft.EntityFrameworkCore.Migrations;

namespace Collector.Migrations
{
    public partial class InitialCreate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Cities",
                columns: table => new
                {
                    CityId = table.Column<int>(nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    CityUrl = table.Column<string>(nullable: true),
                    CityName = table.Column<string>(nullable: true),
                    StateName = table.Column<string>(nullable: true),
                    Latitude = table.Column<string>(nullable: true),
                    Longitude = table.Column<string>(nullable: true),
                    Population = table.Column<long>(nullable: false),
                    NeverMarriedRate = table.Column<double>(nullable: false),
                    NowMarriedRate = table.Column<double>(nullable: false),
                    SeparetedRate = table.Column<double>(nullable: false),
                    WidowedRate = table.Column<double>(nullable: false),
                    DivorceRate = table.Column<double>(nullable: false),
                    NaturalDisasters = table.Column<int>(nullable: false),
                    Police = table.Column<long>(nullable: false),
                    Hopsital = table.Column<int>(nullable: false),
                    MedianIncome = table.Column<long>(nullable: false),
                    CrimeIndex = table.Column<double>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cities", x => x.CityId);
                });

            migrationBuilder.CreateTable(
                name: "TourTraps",
                columns: table => new
                {
                    TourTrapId = table.Column<int>(nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    Title = table.Column<string>(nullable: true),
                    CityId = table.Column<int>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_TourTraps", x => x.TourTrapId);
                    table.ForeignKey(
                        name: "FK_TourTraps_Cities_CityId",
                        column: x => x.CityId,
                        principalTable: "Cities",
                        principalColumn: "CityId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_TourTraps_CityId",
                table: "TourTraps",
                column: "CityId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "TourTraps");

            migrationBuilder.DropTable(
                name: "Cities");
        }
    }
}
