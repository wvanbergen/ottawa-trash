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

ActiveRecord::Schema.define(:version => 20100326002545) do

  create_table "streets", :force => true do |t|
    t.string "full_name"
    t.string "name"
    t.string "prefix"
    t.string "suffix"
  end

  add_index "streets", ["full_name"], :name => "index_streets_on_full_name", :unique => true

  create_table "trash_schedules", :force => true do |t|
    t.integer  "start_nr"
    t.integer  "end_nr"
    t.string   "street"
    t.string   "calendar",   :limit => 1
    t.integer  "day"
    t.boolean  "star"
    t.boolean  "apartment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trash_schedules", ["street", "start_nr"], :name => "index_trash_schedules_on_street_and_start_nr", :unique => true

end
