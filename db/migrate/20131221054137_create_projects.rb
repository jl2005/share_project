class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :user_id
      t.string :name
      t.string :parameter1
      t.string :parameter2
      t.string :comment

      t.timestamps
    end
    add_index :projects, [:user_id, :created_at]
  end
end
