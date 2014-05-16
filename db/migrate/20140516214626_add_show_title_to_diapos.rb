class AddShowTitleToDiapos < ActiveRecord::Migration
  def change
    add_column :diapos, :show_title, :boolean
  end
end
