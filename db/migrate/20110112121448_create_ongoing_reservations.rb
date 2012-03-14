class CreateOngoingReservations < ActiveRecord::Migration
  def self.up
    create_table :ongoing_reservations do |t|
      t.string :cookie

      t.timestamps
    end
  end

  def self.down
    drop_table :ongoing_reservations
  end
end
