class Booking < ApplicationRecord
  enum status: { pending: 0, active: 1, archived: 2, destroying: 99 }

  belongs_to :car
  belongs_to :renter, class_name: "User"

  validates :start_date, :end_date, presence: true

  def duration
    (end_date - start_date).to_i
  end
end
