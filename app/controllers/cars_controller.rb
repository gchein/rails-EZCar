class CarsController < ApplicationController
  before_action :set_car, only: %i[show destroy edit update]

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @car.daily_price = @car.daily_price * 100
    @car.owner = current_user

    if @car.save
      redirect_to cars_path
    else
      render :new, status: :see_other
    end
  end

  def index
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
    @car.update(car_params)
    @car.daily_price = @car.daily_price * 100
    redirect_to profile_path
  end

  def destroy
    @car.destroy
    redirect_to profile_path, status: :see_other
  end

  def search
    if params[:query].present?
      @cars = Car.where('brand ILIKE :query OR model ILIKE :query', query: "%#{params[:query]}%")
    else
      @cars = Car.none
    end

    respond_to do |format|
      format.json { render json: @cars }
    end
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
