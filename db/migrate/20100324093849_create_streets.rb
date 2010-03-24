class CreateStreets < ActiveRecord::Migration
  def self.up
    create_table :streets do |t|
      t.string :full_name
      t.string :name
      t.string :prefix, :length => 20
      t.string :suffix, :length => 20
    end
    
    add_index :streets, :full_name, :unique => true
  end

  def self.down
    drop_table :streets
  end
end
