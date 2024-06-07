json.near_cars @near_cars

json.car_list_html render(partial: "car_card", formats: :html, locals: {cars: @near_cars})
