# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User
User.destroy_all
User.create!(
  name: "admin",
  intro: "Hi, I'm Adimn!",
  job_title: "K-12 Project Developer",
  email: "admin@example.com",
  password: "12345678",
  role: "admin",
  website: "www.k12-project.com",
  share_class_count: [*5..30].sample
  )
puts "Default admin created!"