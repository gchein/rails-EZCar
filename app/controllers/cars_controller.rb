class CarsController < ApplicationController
  before_action :set_car, only: %i[show destroy edit update]

  def index
    @cars = Car.all
  end

  def show
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
    params.require(:car).permit(:brand, :model, :year, :category, :mileage, :color,
                                :license_plate, :description, :availability)
  end

  def set_car
    @car = Car.find(params[:id])
  end
end
