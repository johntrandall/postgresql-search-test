# == Schema Information
#
# Table name: fruits
#
#  id            :bigint           not null, primary key
#  color         :string
#  description   :string
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  god_object_id :bigint
#
# Indexes
#
#  index_fruits_on_god_object_id  (god_object_id)
#
class Fruit < ApplicationRecord
  include PgSearch::Model

  belongs_to :god_object, optional: true
  has_many :vehicles

  has_many :vehicles

  pg_search_scope :search_by_all_human_readable_text, against: [:description, :name, :color]
  pg_search_scope :search_by_text_weighted, against: { name: 'A',
                                                       description: 'B',
                                                       color: 'C' }

  multisearchable(against: [:name, :description, :color],
                  additional_attributes: -> (fruit) { { god_object_id: fruit.god_object_id } })
end
