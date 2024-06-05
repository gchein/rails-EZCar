class BookingsController < ApplicationController
  before_action :set_car, only: %i[new create]
  before_action :set_booking, only: %i[detroy edit update]
  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.car = @car
    @booking.renter = current_user
    @number_of_days = (Date.parse(params[:booking][:end_date]).to_date - Date.parse(params[:booking][:start_date]).to_date).to_i
    @total_cost = @number_of_days * @car.daily_price / 100
    @booking.total_cost = @total_cost

    if @booking.save
      redirect_to profile_path, notice: 'Booking successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @booking.destroy
    redirect_to profile_path, status: :see_other
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      redirect_to profile_path, notice: 'Booking successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_car
    @car = Car.find(params[:car_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
