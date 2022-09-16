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
#  god_object_id     :bigint
#
# Indexes
#
#  index_vehicles_on_fruit_id       (fruit_id)
#  index_vehicles_on_god_object_id  (god_object_id)
#
require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
