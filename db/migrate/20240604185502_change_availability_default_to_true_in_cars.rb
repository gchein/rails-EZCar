class ChangeAvailabilityDefaultToTrueInCars < ActiveRecord::Migration[7.1]
  def change
    change_column_default :cars, :availability, true
  end
end
