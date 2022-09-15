# == Schema Information
#
# Table name: fruits
#
#  id          :bigint           not null, primary key
#  color       :string
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Fruit < ApplicationRecord
  include PgSearch::Model

  has_many :vehicles

  pg_search_scope :search_by_all_human_readable_text, against: [:description, :name, :color]
  pg_search_scope :search_by_text_weighted, against: { name: 'A',
                                                       description: 'B',
                                                       color: 'C' }

  multisearchable against: [:name, :description, :color]
end
