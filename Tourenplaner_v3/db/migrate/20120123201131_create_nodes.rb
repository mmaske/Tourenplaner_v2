class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.string :name
      t.string :street
      t.string :number
      t.string :city
      t.string :country
      t.float :demand
      t.boolean :depot
      t.integer :project_id
      t.string :polyline
      t.integer :tour_id

      t.timestamps
    end
    add_index :nodes, [:project_id]
    add_index :nodes, [:tour_id]
  end

  def self.down
    drop_table :nodes
  end
end
