class Booking < ApplicationRecord
  belongs_to :car
  belongs_to :renter, class_name: "User"

  def duration
    (end_date - start_date).to_i
  end
end
