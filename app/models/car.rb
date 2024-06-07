class Car < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :brand, :model, :license_plate, :daily_price, :address, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
