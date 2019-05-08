using Microsoft.EntityFrameworkCore.Migrations;

namespace Collector.Migrations
{
    public partial class Scores : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<double>(
                name: "HappyScore",
                table: "Cities",
                nullable: false,
                defaultValue: 0.0);

            migrationBuilder.AddColumn<double>(
                name: "SadScore",
                table: "Cities",
                nullable: false,
                defaultValue: 0.0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "HappyScore",
                table: "Cities");

            migrationBuilder.DropColumn(
                name: "SadScore",
                table: "Cities");
        }
    }
}
