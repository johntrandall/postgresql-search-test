class AddSuperHheroVehicleIdToPgSearchDocument < ActiveRecord::Migration[6.1]
  def change
    add_reference :pg_search_documents, :super_hero_vehicle, index: true
  end
end
