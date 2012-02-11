class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.integer :fromnode
      t.integer :tonode
      t.string :polyline
      t.string :fromlatitude
      t.string :fromlongitude
      t.string :tolatitude
      t.string :tolongitude
      t.boolean :gmaps
      t.integer :user_id
      t.integer :tour_id
      t.integer :vehicle_id

      t.timestamps
    end
    add_index :links, [:user_id]
    add_index :links, [:tour_id]
    add_index :links, [:vehicle_id]
  end

  def self.down
    drop_table :links
  end
end
