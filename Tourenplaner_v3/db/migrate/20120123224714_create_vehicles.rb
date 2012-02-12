class CreateVehicles < ActiveRecord::Migration
  def self.up
    create_table :vehicles do |t|
      t.string :VehicleName
      t.string :Type
      t.float :Capacity
      t.integer :project_id
      t.integer :user_id


      t.timestamps
    end
    add_index :vehicles, [:project_id]
    add_index :vehicles, [:user_id]

  end

  def self.down
    drop_table :vehicles
  end
end
