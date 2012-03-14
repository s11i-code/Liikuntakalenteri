# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110207201959) do

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "yol_event_id"
  end

  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "ongoing_reservations", :force => true do |t|
    t.string   "cookie"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "yol_event_url"
    t.integer  "user_id"
  end

  create_table "recognitions", :force => true do |t|
    t.integer  "recogniser_id"
    t.integer  "recognised_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recognitions", ["recognised_id"], :name => "index_recognitions_on_recognised_id"
  add_index "recognitions", ["recogniser_id", "recognised_id"], :name => "index_recognitions_on_recogniser_id_and_recognised_id", :unique => true
  add_index "recognitions", ["recogniser_id"], :name => "index_recognitions_on_recogniser_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.boolean  "approved",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
