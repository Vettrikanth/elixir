# priv/repo/seeds.exs
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:

IO.puts "Seeding database with mock alarm data..."
Logs.Alarm.seed_mock_alarms()
IO.puts "Seeding completed!"
