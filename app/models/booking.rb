class Booking < ApplicationRecord
  belongs_to :car
  belongs_to :renter, class_name: "User"
end
