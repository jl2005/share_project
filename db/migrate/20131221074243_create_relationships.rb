class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
    add_index :relationships, :user_id
    add_index :relationships, :project_id
    add_index :relationships, [:user_id, :project_id], unique: true
  end
end
