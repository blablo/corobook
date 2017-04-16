class AddSongsTextBgColorToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :songs_text_bg_color, :string, :default => "none"
  end
end
