class AddUserToOngoingReservation < ActiveRecord::Migration
  def self.up
    add_column :ongoing_reservations, :user_id, :integer
  end

  def self.down
    remove_column :ongoing_reservations, :user_id
  end
end
