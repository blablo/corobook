class CreatePresentations < ActiveRecord::Migration
  def change
    create_table :presentations do |t|
      t.datetime :fecha

      t.timestamps
    end
  end
end
