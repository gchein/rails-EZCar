class Booking < ApplicationRecord
  enum status: { pending: 0, active: 1, archived: 2 }

  belongs_to :car
  belongs_to :renter, class_name: "User"

  validates :start_date, :end_date, presence: true

  def set_default_status
    self.status ||= :pending
  end

  def duration
    (end_date - start_date).to_i
  end
end
