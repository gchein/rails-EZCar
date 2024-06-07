class CarsController < ApplicationController
  before_action :set_car, only: %i[show destroy edit update]

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @car.daily_price = @car.daily_price * 100
    @user = current_user
    @car.owner = @user

    if @car.save
      redirect_to cars_path
    else
      render :new, status: :see_other
    end
  end

  def index
    respond_to do |format|
      format.html {
        @cars = Car.where(availability: true).order("id")
        @markers = @cars.geocoded.map do |car|
          {
            lat: car.latitude,
            lng: car.longitude,
            info_window_html: render_to_string(partial: "info_window", locals: { car: }),
            car_mark_html: render_to_string(partial: "car_mark", locals: { car: })
          }
        end
      }

      format.json {
        @map_json = map_params
        @near_cars = Car.near([@map_json['lat'], @map_json['lng']], 2).where(availability: true).order("id")
      }
    end
  end

  def show
    @booking = Booking.new
  end

  def edit
  end

  def update
    updated_params = car_params
    updated_params[:daily_price] = updated_params[:daily_price].to_i * 100

    if @car.update(updated_params)
      @car.daily_price = @car.daily_price * 100
      redirect_to profile_path, notice: 'Car successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @car.destroy

    redirect_to profile_path, status: :see_other
  end

  private

  def car_params
    params.require(:car).permit(:brand, :model, :year, :category, :mileage,
                                :color, :license_plate, :description, :daily_price, :availability, :address)
  end

  def map_params
    params.permit(:lat, :lng)
  end

  def set_car
    @car = Car.find(params[:id])
  end
end
