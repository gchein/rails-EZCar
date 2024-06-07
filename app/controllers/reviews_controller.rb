class ReviewsController < ApplicationController
  before_action :set_car, only: %i[new create]

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.user = current_user
    @review.car = @car
    if @review.save
      redirect_to @car, notice: 'Review was successfully created.'
    else
      flash[:alert] = "Something went wrong."
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end

  def set_car
    @car = Car.find(params[:car_id])
  end
end
