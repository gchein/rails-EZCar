class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cars_as_owner, class_name: "Car", foreign_key: :owner_id, dependent: :destroy
  has_many :bookings_as_renter, class_name: "Booking", foreign_key: :renter_id, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
