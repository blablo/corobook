class CreateGroupCollaborators < ActiveRecord::Migration
  def change
    create_table :group_collaborators do |t|
      t.string :email
      t.integer :user_id
      t.string :name
      t.integer :role
      t.integer :group_id

      t.timestamps
    end
  end
end
