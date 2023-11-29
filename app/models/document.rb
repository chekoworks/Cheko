class Document < ApplicationRecord
  belongs_to :homework

  has_many :tags, dependent: :destroy

  has_one_attached :file
end
