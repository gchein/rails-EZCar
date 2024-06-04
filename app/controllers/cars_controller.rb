class CarsController < ApplicationController
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

  private

  def car_params
    params.require(:car).permit(:brand, :model, :year, :category, :mileage,
                                :color, :license_plate, :description, :daily_price)
  end
end
