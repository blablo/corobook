class CreateDiapos < ActiveRecord::Migration
  def change
    create_table :diapos do |t|
      t.string :title
      t.text :info
      t.string :background

      t.timestamps
    end
  end
end
