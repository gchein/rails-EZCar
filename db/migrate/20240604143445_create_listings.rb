class CreateListings < ActiveRecord::Migration[7.1]
  def change
    create_table :listings do |t|
      t.references :car, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :daily_price
      t.string :location

      t.timestamps
    end
  end
end
