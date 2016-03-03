class AddEasyDateToAnniversaries < ActiveRecord::Migration
  def change
    add_column :anniversaries, :easy_date, :int
  end
end
