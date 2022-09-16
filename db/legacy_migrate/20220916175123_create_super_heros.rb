class CreateSuperHeros < ActiveRecord::Migration[6.1]
  def change
    create_table :super_heros do |t|
      t.string :name
      t.string :superpower
      t.references :god_object
      t.references :vehicle
      t.references :fruit

      t.timestamps
    end
  end
end
