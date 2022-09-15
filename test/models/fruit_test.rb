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
  test "the truth" do
    assert true
  end

  test "Search works" do
    # noise
    green_apple = Fruit.create!(name: "apple", color: "green", description: "large, round, yummy")
    banana = Fruit.create!(name: "banana", color: "yellow", description: "soft and eaten by monkeys")

    # match
    red_apple = Fruit.create!(name: "apple", color: "red", description: "large, round, with a worm")
    mini_best = Fruit.create!(name: "worm", color: "pink", description: "OMG I am not a fruit but I show up in search because its in my name")

    assert_equal Fruit.search_by_all_human_readable_text("worm"), [red_apple, mini_best]
  end
end
