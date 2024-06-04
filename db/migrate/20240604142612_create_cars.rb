class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :brand
      t.string :model
      t.integer :year
      t.string :category
      t.integer :mileage
      t.string :color
      t.string :license_plate
      t.text :description
      t.boolean :availability

      t.timestamps
    end
  end
end
