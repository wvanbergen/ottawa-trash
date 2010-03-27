class CreateTrashSchedules < ActiveRecord::Migration
  def self.up
    create_table :trash_schedules do |t|
      t.integer :start_no
      t.integer :end_no
      t.string  :street
      t.string  :street_type, :length => 10
      t.string  :community
      t.string  :calendar, :limit => 1
      t.integer :day
      
      t.boolean :star
      t.boolean :apartment

      t.timestamps
    end
    
    add_index :trash_schedules, [:street, :start_no], :unique => true
  end

  def self.down
    drop_table :trash_schedules
  end
end
