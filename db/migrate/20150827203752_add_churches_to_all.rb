class AddChurchesToAll < ActiveRecord::Migration
  def change

    add_column :presentations, :church_id, :integer
    add_column :users, :church_id, :integer
    add_column :diapos, :church_id, :integer
    add_column :songbooks, :church_id, :integer
    add_column :songs, :church_id, :integer
    
    add_index :presentations, :church_id
    add_index :users, :church_id
    add_index :diapos, :church_id
    add_index :songbooks, :church_id
    add_index :songs, :church_id


  end
end
