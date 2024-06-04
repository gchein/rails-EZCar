class AddDailyPriceToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :daily_price, :integer
  end
end
