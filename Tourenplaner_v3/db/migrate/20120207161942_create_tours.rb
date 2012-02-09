class CreateTours < ActiveRecord::Migration
  def self.up
    create_table :tours do |t|
      t.string :servicetime
      t.string :maxduration
      t.integer :user_id


      t.timestamps
    end
    add_index :tours, [:user_id]
  end

  def self.down
    drop_table :tours
  end
end
