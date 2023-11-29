class School < ApplicationRecord
  has_many :professors
  has_many :prof_reviews
end
