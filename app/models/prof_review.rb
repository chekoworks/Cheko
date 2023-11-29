class ProfReview < ApplicationRecord
  belongs_to :user
  belongs_to :professor, optional: true
  belongs_to :school, optional: true
  
  enum status: { approved: 0, pending: 1 }

  def name
    return "#{self.first_name} #{self.last_name}"
  end
end
