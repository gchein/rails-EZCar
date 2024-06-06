class Car < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :bookings, dependent: :destroy

  validates :brand, :model, :license_plate, :daily_price, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
