# == Schema Information
#
# Table name: god_objects
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class GodObject < ApplicationRecord
  has_many :fruits
  has_many :vehicles
end
