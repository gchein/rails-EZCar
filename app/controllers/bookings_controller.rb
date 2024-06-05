class BookingsController < ApplicationController
  before_action :set_booking, only: %i[detroy edit update]

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

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date)
  end
end
