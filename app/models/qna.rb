class Qna < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :tutor, optional: true
  belongs_to :qna_type

  has_one :chat

  has_many_attached :document_attachments
  has_one_attached :payment_receipt

  enum status:         {pending: 0, assigned: 1, done: 2, cancelled: 3}
  # enum qna_type:       {essay: 0, art: 2, group_project: 3, law: 4, math: 5, science: 6, translation: 7, code: 8, economics: 9 }
  enum payment_status:  {unpaid: 0, paid: 1}
  after_create :create_auth
  validates :amount, numericality: {only_integer: true, greater_than: 0, less_than: 2**31, allow_nil: true}

  def create_auth
    hex = SecureRandom.hex

    self.auth = hex
    self.save
  end
end
