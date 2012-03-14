class AddYolEventIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :yol_event_id, :string
  end

  def self.down
    remove_column :events, :yol_event_id
  end
end
