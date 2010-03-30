class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.string  :email
      t.string  :calendar, :length => 1
      t.integer :day

      t.timestamps
    end
    
    add_index :subscriptions, [:email, :calendar, :day], :unique => true
  end

  def self.down
    drop_table :subscriptions
  end
end
