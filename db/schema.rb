# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100330011716) do

  create_table "subscriptions", :force => true do |t|
    t.string   "email"
    t.string   "calendar"
    t.integer  "day"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["email", "calendar", "day"], :name => "index_subscriptions_on_email_and_calendar_and_day", :unique => true

  create_table "trash_schedules", :force => true do |t|
    t.integer  "start_no"
    t.integer  "end_no"
    t.string   "street"
    t.string   "street_type"
    t.string   "community"
    t.string   "calendar",    :limit => 1
    t.integer  "day"
    t.boolean  "star"
    t.boolean  "apartment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trash_schedules", ["street", "start_no"], :name => "index_trash_schedules_on_street_and_start_no", :unique => true

end
