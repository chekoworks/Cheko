class Homework < ApplicationRecord
  # include HTTParty
  
  belongs_to :user
  belongs_to :tutor, optional: true
  belongs_to :sub_tutor, class_name: "Tutor", optional: true
  belongs_to :manager, optional: true
  belongs_to :admin, optional: :true
  # belongs_to :subject

  has_many :documents, dependent: :destroy
  has_many :bids, dependent: :destroy

  has_many_attached :hw_attachment

  enum order_type:     { essay: 0, thesis: 1, art: 2, group_project: 3, law: 4, math: 5, science: 6, translation: 7, code: 8, economics: 9, sketchup: 10, foreign_language: 11, robotics: 12, module: 13 }
  enum payment_type:   { gcash: 0, bank: 1 }
  enum payment_status: { unpaid: 0, paid: 1 }
  enum status:         { reviewing: 0, cancel: 1, ongoing: 2, done: 3, in_draft: 4, deleted: 5, finished_by_tutor:6}
  enum grade:          { a: 0, b: 1, c: 2 }
  enum tutor_category: { a_plus: 0, cheko: 1, standard: 2 }

  scope :not_deleted, -> { where(soft_deleted: false) }
  scope :deleted, -> { where(soft_deleted: true) }

  #create the soft delete method
  def soft_delete
    update(soft_deleted: true)
  end

  # make an undelete method
  def undelete
    update(soft_deleted: false)
  end

  def accept_order
    # logger.info "\n \n #{self.name}"
    self.status = "ongoing"
    if !self.name.present?
      self.name = "#{self.user.first_name[0,1].capitalize}#{self.user.last_name[0,1].capitalize}_#{self.subject}##{self.deadline.strftime("%b%m")}_#{self.admin.first_name[0,1].capitalize}#{self.admin.last_name[0,1].capitalize}"
    end
    self.save
  end

  def profit
    return self.price.to_i - self.tutor_price.to_i
  end

  def finish_order
    self.status = "done"
    self.save
  end

  def approve_payment
    self.payment_status = "paid"
    self.save
  end

  def assign_tutor(bid, price_given=nil)
    logger.info "\n\n #{price_given}\n\n"
    price = price_given.nil? ? bid.ammount : price_given
    # bid = Bid.find_by(homework_id: self.id, tutor_id: tutor_id)
    if bid.nil?
      self.update!(tutor_price: price)
    else
      self.tutor_id == bid.tutor_id ? self.update!(tutor_price: price) : self.update!(tutor_id: bid.tutor_id, tutor_price: price)
    end
    # self.tutor_id = tutor_id
    # self.tutor_price = bid.ammount
    # self.save
  end

  def draft 
    self.status = "draft"
    self.save
  end
end
