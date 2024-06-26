class BookingsController < ApplicationController
  before_action :set_booking, only: %i[destroy edit update]
  before_action :set_car, only: %i[new create]

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.car = @car
    @booking.renter = current_user

    @start_date = @booking.start_date
    @end_date = @booking.end_date

    unless @start_date.nil? || @end_date.nil?
      @number_of_days = (@end_date - @start_date).to_i
      @total_cost = @number_of_days * @car.daily_price / 100
      @booking.total_cost = @total_cost
    end

    if @booking.save
      redirect_to profile_path, notice: 'Booking successfully created.'
    else
      render 'cars/show', status: :unprocessable_entity
    end
  end

  def destroy
    if @booking.status == 'destroying' || @booking.status == 'pending'
      @booking.destroy
      redirect_to profile_path, status: :see_other
    else
      @booking.status = 'destroying'
      @booking.save
    end
  end

  def edit
  end

  def update
    @car = @booking.car
    if params[:booking].key?(:start_date)
      @start_date = Date.parse(params[:booking][:start_date]).to_date
    else
      @start_date = @booking.start_date
    end

    if params[:booking].key?(:end_date)
      @end_date = Date.parse(params[:booking][:end_date]).to_date
    else
      @end_date = @booking.end_date
    end

    @number_of_days = (@end_date - @start_date).to_i
    @total_cost = @number_of_days * @car.daily_price / 100
    @booking.total_cost = @total_cost

    if @booking.valid?
      if @booking.status == 'pending' || @booking.status == 'destroying'
        @booking.update(booking_params)
        redirect_to profile_path, notice: 'Booking successfully updated.'
      else
        redirect_back fallback_location: edit_booking_path(@booking), notice: "This booking has already been accepted by the owner, and can't be updated."
      end

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
    params.require(:booking).permit(:start_date, :end_date, :status)
  end
end
