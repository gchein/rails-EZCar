class ChangeStatusOnBookingsFromBooleanToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :bookings, :status, :integer, using: 'status::integer'
  end
end
