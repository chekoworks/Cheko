class Professor < ApplicationRecord
  has_many :prof_reviews
  belongs_to :school, optional: true

  def name
    return "#{self.first_name} #{self.last_name}"
  end

  def update_grading
    reviews = self.prof_reviews.where(status: "approved")
    approve_count = reviews.count

    easiness = reviews.average(:easiness).to_i
    effectiveness = reviews.average(:effectiveness).to_i
    life_changing = reviews.average(:life_changing).to_i
    light_workload = reviews.average(:light_workload).to_i
    leniency = reviews.average(:leniency).to_i
    
    average = easiness + effectiveness + life_changing + light_workload + leniency
    average = average/5

    hash = {
      easiness: easiness,
      effectiveness: effectiveness,
      life_changing: life_changing,
      light_workload: light_workload,
      leniency: leniency,
      average: average.to_f,
      a_able: reviews.average(:a_able).to_i,
      b_pls_able: reviews.average(:b_pls_able).to_i,
      b_able: reviews.average(:b_able).to_i,
      c_able: reviews.average(:c_able).to_i,
      batch1_able: reviews.average(:batch1_able).to_i,
      batch2_able: reviews.average(:batch2_able).to_i,
      batch3_able: reviews.average(:batch3_able).to_i,
      batch4_able: reviews.average(:batch4_able).to_i
    }

    self.update(hash)
  end

  def set_up_email
    # professor = self.professor

    if self.school.name == "DLSU"
      self.dlsu_email
    elsif self.school.name == "ADMU" 
      self.admu_email
    end
  end

  def admu_email
    fname = self.first_name

    fname.split(" ").each do |name|
      fcharacter = name.first.downcase
      next if Professor.find_by(email: "#{fcharacter}#{self.last_name.downcase}@ateneo.edu")
      self.update!(email: "#{fcharacter}#{self.last_name.downcase}@ateneo.edu")
      break
    end
  end

  def dlsu_email
    new_name = ""
    fname = self.first_name
    fname.split(" ").each_with_index do |name, ind|
      if ind == 0
        new_name.concat(name.downcase)
      else
        new_name.concat(".#{name.downcase}")
      end
    end

    email = "#{new_name}.#{self.last_name.gsub(/\s+/, "").downcase}@dlsu.edu.ph"
    self.update(email: email)
  end
end
