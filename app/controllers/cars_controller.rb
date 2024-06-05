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
    @cars = Car.all
  end

  def show
    @booking = Booking.new
  end

  def edit
  end

  def update
    @car = Car.update(car_params)
    redirect_to car_path(@car)
  end

  def destroy
    @car.destroy

    redirect_to cars_path, status: :see_other
  end

  private

  def car_params
    params.require(:car).permit(:brand, :model, :year, :category, :mileage,
                                :color, :license_plate, :description, :daily_price, :availability)
  end

  def set_car
    @car = Car.find(params[:id])
  end
end
