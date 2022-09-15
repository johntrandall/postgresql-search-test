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
require "test_helper"

class FruitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
