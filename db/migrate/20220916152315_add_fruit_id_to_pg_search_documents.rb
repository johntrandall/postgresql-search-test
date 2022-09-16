class AddFruitIdToPgSearchDocuments < ActiveRecord::Migration[6.1]
  def change
    add_reference :pg_search_documents, :fruit, index: true
  end
end
