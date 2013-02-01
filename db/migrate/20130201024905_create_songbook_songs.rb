class CreateSongbookSongs < ActiveRecord::Migration
  def change
    create_table :songbook_songs do |t|
      t.integer :song_id
      t.integer :songbook_id
      t.integer :order

      t.timestamps
    end
  end
end
