class CreateGodObjects < ActiveRecord::Migration[6.1]
  def change
    create_table :god_objects do |t|
      t.string :name

      t.timestamps
    end
  end
end
