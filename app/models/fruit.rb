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
  pg_search_scope :search_by_all_human_readable_text, against: [:description, :name, :color]

  has_many :vehicles
end
