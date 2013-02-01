class CreateSongbooks < ActiveRecord::Migration
  def change
    create_table :songbooks do |t|
      t.string :title

      t.timestamps
    end
  end
end
