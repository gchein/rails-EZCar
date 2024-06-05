class BookingsController < ApplicationController
  before_action :set_booking, only: %i[detroy]
  def destroy
    @booking.destroy
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
    redirect_to bookings_path, status: :see_other
  end
end
