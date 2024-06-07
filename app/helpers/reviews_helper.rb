module ReviewsHelper
  def star_rating(rating)
    return "No rating" if rating.nil? # You can customize this message as needed
    "&#9733;" * rating
  end
end
