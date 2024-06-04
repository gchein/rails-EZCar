class CarsController < ApplicationController
  def edit
    @car = Car.find(params[:id])
  end

  def update
    @car = Car.find(params[:id])
    @car = Car.update(car_params)
    redirect_to car_path(@car)
  end

  private

  def car_params
    params.require(:car).permit(:brand, :model, :year, :category, :mileage, :color,
                                :license_plate, :description, :availability)
  end
end
