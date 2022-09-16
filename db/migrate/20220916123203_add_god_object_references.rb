class AddGodObjectReferences < ActiveRecord::Migration[6.1]
  def change
    add_reference :pg_search_documents, :god_object, index: true
    add_reference :fruits, :god_object, index: true
    add_reference :vehicles, :god_object, index: true
  end
end
