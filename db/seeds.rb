# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

subjects = [
  {name: "English", status: 1},
  {name: "Physics", status: 1},
  {name: "Philosophy", status: 1},
  {name: "Math", status: 1},
]

puts "\n --- creating subjects desuwa --- \n"
if Subject.all.count == 0
  subjects.each do |subj|
    Subject.create!(subj)
  end
end
puts "\n --- subjects okay desuwa ---\n"

puts "\n --- creating schools desuwa --- \n"
schools = [
  {name: "University of the Philippines Diliman"},
  {name: "De La Salle University"},
  {name: "College of Saint Benilde"},
  {name: "Ateneo de Manila University"},
  {name: "University of Asia & Pacific"},
  {name: "Enderun Colleges"},
  {name: "Others"}
]

if School.all.count == 0
  schools.each do |school|
    School.create!(school)
  end
end
puts "\n --- schools okay desuwa --- \n"

puts "\n --- creating qna types desuwa --- \n"
types = [
  {name: "math"},
  {name: "econ"},
  {name: "accounting"},
  {name: "engineering"},
  {name: "machine learning"},
  {name: "law"},
  {name: "essay"},
  {name: "programming"},
  {name: "robotics"},
  {name: "stat"},
  {name: "tech"},
  {name: "others"}
]

if QnaType.all.count == 0
  types.each do |type|
    QnaType.create!(type)
  end
end
puts "\n --- qna types okay desuwa --- \n"

#TODO Add admin seeder desuwa

puts "\n --- creating admin seeder desuwa --- \n"

if Admin.all.count == 0
  Admin.create!(
    first_name: "Admin",
    last_name: "Cheko",
    email: "admin@cheko.com",
    password: "Adm!nP@ssw0rD",
    password_confirm: "Adm!nP@ssw0rD"
    role: 1
  )
end
puts "\n --- admin seeder desuwa --- \n"

