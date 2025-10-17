# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!(
  name: "John Doe",
  username: "johnd",
  school: "Springfield High",
  password: "password123",
  bio: "I love coding!",
  alien_points: 50,
  blastoff_points: 20,
  avatar: nil
)

User.create!(
  name: "Breanna L",
  username: "bwanafy",
  school: "Adelaide Uni",
  password: "pass1",
  bio: "Hello",
  alien_points: 50,
  blastoff_points: 20,
  avatar: nil
)

User.create!(
  name: "Sally",
  username: "rocketgal",
  school: "Adelaide Uni",
  password: "pass2",
  bio: ";)",
  alien_points: 50,
  blastoff_points: 20,
  avatar: nil
)
