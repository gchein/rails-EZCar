# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'
require 'open-uri'
require 'json'

puts "Cleaning car database..."
Car.destroy_all
puts "Done!"


puts "Cleaning user database..."
User.destroy_all
puts "Done!"

40.times do |_i|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  email = Faker::Internet.email(name: "#{first_name} #{last_name}", separators: ['_'])
  password = Faker::Internet.password

  puts "Seeding #{first_name} #{last_name} - #{email}"
  User.create!(first_name:, last_name:, email:, password:)
end
puts "Done!"

car_api_url_base = 'https://carapi.app/api/bodies?verbose=yes&json=%5B%7B%22field%22%3A%22year%22%2C%22op%22%3A%22%3E%3D%22%2C%22val%22%3A2015%7D%2C%7B%22field%22%3A%22year%22%2C%22op%22%3A%22%3C%3D%22%2C%22val%22%3A2020%7D%5D' # &page=1
# iterar pelas páginas, depois pelos resultados das páginas (de 1 a 100), e por fim pegar os dados desse resultado randômico da iteração.
# https://carapi.app/api

car_api_result = URI.open(car_api_url_base).read
car_api_json = JSON.parse(car_api_result)

n_pages = car_api_json['collection']['pages']
n_cars = 20

page_jump = n_pages / n_cars
current_page = 1

owners_index = (1..User.all.count).to_a.sample(20)

puts "Creating cars..."
owners_index.each do |i|

  owner = User.find(i)

  current_page += page_jump

  car_api_url = "#{car_api_url_base}&page=#{current_page}"
  car_api_result = URI.open(car_api_url).read
  car_api_json = JSON.parse(car_api_result)

  # make_and_model = Faker::Vehicle.make_and_model

  car_hash = car_api_json['data'][(1..100).to_a.sample]

  brand = car_hash['make_model_trim']['make_model']['make']['name'] # make_and_model.split[0]
  model = car_hash['make_model_trim']['make_model']['name'] # make_and_model.split[1]
  year = car_hash['make_model_trim']['year'] # Faker::Vehicle.year
  category = car_hash['type']
  mileage = Faker::Vehicle.mileage(min: 5_000, max: 50_000)
  color = Faker::Vehicle.color
  license_plate = Faker::Vehicle.license_plate
  description = car_hash['make_model_trim']['description']
  availability = true

  new_car_hash = {
                    brand:,
                    model:,
                    year:,
                    category:,
                    mileage:,
                    color:,
                    license_plate:,
                    description:,
                    availability:
                    }


 new_car = Car.new(new_car_hash)
 new_car.owner = owner

 new_car.save!
end
puts "Done!"
