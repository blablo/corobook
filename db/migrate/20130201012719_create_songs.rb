class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :title
      t.string :author
      t.text :lyric
      t.integer :user_id
      t.string :link
      t.string :reference
      t.integer :mood
      t.string :order

      t.timestamps
    end
  end
end
