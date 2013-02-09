class AddFechaToSongbooks < ActiveRecord::Migration
  def change
    add_column :songbooks, :fecha, :date
  end
end
