class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :songs_background
      t.string :songs_case, default: 'none'
      t.string :church_id
      t.string :songs_font_color, default: '#FFFFFF'
      t.string :presentation_template

      t.timestamps
    end
    add_index :settings, :church_id
  end
end
