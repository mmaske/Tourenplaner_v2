class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.boolean :distance_accuracy
      t.boolean :duration_accuracy
      t.integer :user_id

      t.timestamps
    end
    add_index :projects, [:user_id]



  end

  def self.down
    drop_table :projects
  end
end
