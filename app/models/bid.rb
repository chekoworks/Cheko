class Bid < ApplicationRecord
  belongs_to :tutor
  belongs_to :homework

  #add validation not to exceed int limit
  validates :ammount, numericality: {only_integer: true, greater_than: 0, less_than: 2**31, allow_nil: true}
end
