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
require 'nokogiri'
require 'cgi'

def fetch_image_url(car_year, car_brand, car_model)
  search_query = "#{car_year} #{car_brand} #{car_model} car"
  google_search_url = "https://www.google.com/search?hl=en&tbm=isch&q=#{CGI.escape(search_query)}"
  begin
    html = URI.open(google_search_url).read
    doc = Nokogiri::HTML.parse(html)
    first_image = doc.css("img")[20] # Adjust the index if necessary

    first_image_url = first_image['src'] || first_image['data-src'] # Adjust the index if necessary
  rescue => e
    puts "Error fetching image URL: #{e.message}"
    first_image_url = nil
  end
  first_image_url
end

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

puts "Total pages: #{n_pages}"
page_jump = n_pages / n_cars
current_page = 1

owners_index = (0..User.all.count - 1).to_a.sample(n_cars)

address_one = 'Rua Visconde De Pirajá '
address_two = ', Ipanema, Rio de Janeiro - Rio de Janeiro, Brasil'
address_num = 0

puts "Creating cars..."
owners_index.each do |i|

  owner = User.all[i]
  address_num += 20
  address = "#{address_one}#{address_num}#{address_two}"

  current_page += page_jump

  car_api_url = "#{car_api_url_base}&page=#{current_page}"
  car_api_result = URI.open(car_api_url).read
  car_api_json = JSON.parse(car_api_result)

  # make_and_model = Faker::Vehicle.make_and_model

  car_hash = car_api_json['data'][(0..99).to_a.sample]
  brand = car_hash['make_model_trim']['make_model']['make']['name'] # make_and_model.split[0]
  model = car_hash['make_model_trim']['make_model']['name'] # make_and_model.split[1]
  year = car_hash['make_model_trim']['year'] # Faker::Vehicle.year
  category = car_hash['type']
  mileage = Faker::Vehicle.mileage(min: 5_000, max: 50_000)
  color = Faker::Vehicle.color
  license_plate = Faker::Vehicle.license_plate
  description = car_hash['make_model_trim']['description']
  availability = true
  daily_price = 10000

  new_car_hash = {
                    brand:,
                    model:,
                    year:,
                    category:,
                    mileage:,
                    color:,
                    license_plate:,
                    description:,
                    availability:,
                    daily_price:,
                    address:
                  }


  new_car = Car.new(new_car_hash)

  new_car.owner = owner

  puts "Seeding #{brand} #{model} from page #{current_page}, on address: #{address}"
  new_car.save!

  # cars.each do |car|
  #   image_url = fetch_image_url(car[:year], car[:brand], car[:model])
  #   if image_url
  #     Car.create(year: car[:year], brand: car[:brand], model: car[:model], image_url: image_url)
  #     puts "Created #{car[:year]} #{car[:brand]} #{car[:model]} with image URL: #{image_url}"
  #   else
  #     puts "Failed to fetch image for #{car[:year]} #{car[:brand]} #{car[:model]}"
  #   end
  # end

  file = URI.open(fetch_image_url(new_car_hash[:year], new_car_hash[:brand], new_car_hash[:model]))

  new_car.photos.attach(io: file, filename: "nes.png", content_type: "image/png")

  new_car.save
  end
puts "Done!"

master_first_name = "Leo"
master_last_name = "Wagon"
master_email = "ezcar1685@gmail.com"
master_password = "lewagon1685"
puts "Creating master user #{master_first_name} #{master_last_name}"

User.create!(first_name: master_first_name, last_name: master_last_name, email: master_email, password: master_password)
puts "Done!"

test_renter_first_name = "José"
test_renter_last_name = "das Couves"
test_renter_email = "zezin_couve@gmail.com"
test_renter_password = "kalelover123"
puts "Creating test renter user #{test_renter_first_name} #{test_renter_last_name}"

User.create!(first_name: test_renter_first_name, last_name: test_renter_last_name, email: test_renter_email, password: test_renter_password)
puts "Done!"
