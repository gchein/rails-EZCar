class CarsController < ApplicationController
  before_action :set_car, only: %i[show destroy edit update]

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @user = current_user
    @car.owner = @user

    if @car.save
      redirect_to cars_path
    else
      render :new, status: :see_other
    end
  end

  def index
    @car = Car.new
    @cars = Car.all.order("id")
    @markers = @cars.geocoded.map do |car|
      {
        lat: car.latitude,
        lng: car.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { car: }),
        car_mark_html: render_to_string(partial: "car_mark", locals: { car: })
      }
    end
  end

  def show
    @booking = Booking.new
  end

  def edit
  end

  def update
    @car = Car.update(car_params)
    redirect_to profile_path
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

  def set_car
    @car = Car.find(params[:id])
  end
end
