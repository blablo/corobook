class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.integer :order
      t.integer :song_id
      t.integer :diapo_id
      t.integer :presentation_id

      t.timestamps
    end
  end
end
