class AddAnniversariesBackgroundToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :anniversaries_background, :string
  end
end
