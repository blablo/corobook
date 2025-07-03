class AddGroupIdToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :group_id, :integer
    add_index :songs, :group_id
  end
end
