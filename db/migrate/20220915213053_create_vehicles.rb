class CreateVehicles < ActiveRecord::Migration[6.1]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :description
      t.string :wheel_description
      t.references :fruit

      t.timestamps
    end
  end
end
