class AddAddressToCars < ActiveRecord::Migration[7.1]
  def change
    add_column :cars, :address, :string
  end
end
