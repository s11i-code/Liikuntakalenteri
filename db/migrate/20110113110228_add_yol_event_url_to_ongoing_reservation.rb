class AddYolEventUrlToOngoingReservation < ActiveRecord::Migration
  def self.up
    add_column :ongoing_reservations, :yol_event_url, :string
  end

  def self.down
    remove_column :ongoing_reservations, :yol_event_url
  end
end
