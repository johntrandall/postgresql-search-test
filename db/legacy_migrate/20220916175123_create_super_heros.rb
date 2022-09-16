class CreateSuperHeros < ActiveRecord::Migration[6.1]
  def change
    create_table :super_heros do |t|
      t.string :name
      t.string :superpower
      t.references :vehicle

      t.timestamps
    end
  end
end
