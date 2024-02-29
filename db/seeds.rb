# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'roo'

if ENV['prof_review'] == "true"
  puts "\n --- PROF_REVIEW okay desuwa ---\n"
  file_name = './db/cheko_prof5.xlsx'
  excel = Roo::Spreadsheet.open(file_name, {:expand_merged_ranges => true})

  sheets = excel.sheets
  sheets.shift

  prof_ids = []
  sheets.each_with_index do |sheet, index|

    parsed = excel.sheet(sheet).parse(headers: true)

    parsed.each_with_index do |parse, index|
      next if index == 0

      if parse['professor_id'] == nil && parse['first_name'] != nil
        if Professor.where(first_name: parse['first_name'])
          prof = Professor.where(first_name: parse['first_name']).first
          prof_ids.insert(0, prof.id)
          puts "\n --- skip ---\n" 
          next
        end
        
        school = School.find_by(name: "Ateneo de Manila University")
        puts "\n --- creating professor desuwa ---\n" 
        Professor.create(['first_name' => parse['first_name'], 'last_name' => parse['last_name'], 'school_id' => school.id])
      else
        if ProfReview.where(content: parse['content']).first
          rev = ProfReview.where(content: parse['content']).first
          rev.update(user_initials: parse['user_id'])
          prof_ids.insert(0, rev.professor_id)
          puts "\n --- skip ---\n" 
          next
        end

        puts "\n --- inserting prof review desuwa" + parse['professor_id'].to_s + " ---\n" 
        parse.delete("Facebook link")
        parse.delete("user_id")
        parse.delete("subject/s")
  
        rev = ProfReview.create(parse)
        prof_ids.insert(0, rev.professor_id)
      end
    end
  end


  Professor.all.each do |prof|
    prof.update_grading
  end
end

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
    # password_confirm: "Adm!nP@ssw0rD"
    role: 1
  )
end
puts "\n --- admin seeder desuwa --- \n"
