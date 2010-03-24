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

ActiveRecord::Schema.define(:version => 20100324093849) do

  create_table "streets", :force => true do |t|
    t.string "full_name"
    t.string "name"
    t.string "prefix"
    t.string "suffix"
  end

  add_index "streets", ["full_name"], :name => "index_streets_on_full_name", :unique => true

end
