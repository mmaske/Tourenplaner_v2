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

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
