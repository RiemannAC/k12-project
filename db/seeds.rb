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
  title: "K-12 Project Developer",
  email: "admin@example.com",
  password: "12345678",
  role: "admin",
  website: "www.k12-project.com",
  share_class_count: [*5..30].sample
  )
puts "Default admin created!"
####################################
# Topic
Topic.destroy_all
topic_list = [
  { name: "國文" },
  { name: "英文" },
  { name: "數學" },
  { name: "社會" },
  { name: "自然" },
  { name: "生活科技" },
  { name: "藝術" },
  { name: "音樂" },
  { name: "體育" },
  { name: "班級經營" },
  { name: "家政" },
  { name: "健康教育" },
  { name: "其他" }
]

topic_list.each do |topic|
  Topic.create!( name: topic[:name] )
end
puts "Topic created!"
