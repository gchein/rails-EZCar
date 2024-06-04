class CarsController < ApplicationController
  before_action :set_car, only: %i[show destroy]

  def index
    @cars = Car.all
  end

  def show
  end

  def destroy
    @car.destroy

    redirect_to cars_path, status: :see_other
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end
end
