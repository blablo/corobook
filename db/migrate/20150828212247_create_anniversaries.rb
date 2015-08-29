class CreateAnniversaries < ActiveRecord::Migration
  def change
    create_table :anniversaries do |t|
      t.datetime :date
      t.string :name
      t.string :category
      t.string :church_id

      t.timestamps
    end
    add_index :anniversaries, :church_id
  end
end
