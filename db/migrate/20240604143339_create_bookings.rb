class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :car, null: false, foreign_key: true
      t.references :renter, null: false, foreign_key: { to_table: :users }
      t.date :start_date
      t.date :end_date
      t.integer :total_cost
      t.boolean :status

      t.timestamps
    end
  end
end
