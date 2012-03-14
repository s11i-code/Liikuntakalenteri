class CreateRecognitions < ActiveRecord::Migration
  create_table :recognitions do |t|
    t.integer :recogniser_id
    t.integer :recognised_id

    t.timestamps
  end
  add_index :recognitions, :recogniser_id
  add_index :recognitions, :recognised_id
  add_index :recognitions, [:recogniser_id, :recognised_id], :unique => true
end
