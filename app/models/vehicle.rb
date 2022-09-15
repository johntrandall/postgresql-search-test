# == Schema Information
#
# Table name: vehicles
#
#  id                :bigint           not null, primary key
#  description       :string
#  name              :string
#  wheel_description :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  fruit_id          :bigint
#
# Indexes
#
#  index_vehicles_on_fruit_id  (fruit_id)
#
class Vehicle < ApplicationRecord
  belongs_to :fruit
end
