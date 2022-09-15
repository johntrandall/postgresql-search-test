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

  test "weighted by column search works" do
    Fruit.create!(name: "worm in name WEIGHT A", color: "green", description: "large, round, yummy")
    Fruit.create!(name: "in description WEIGHT B", color: "red", description: "half a worm in me")
    Fruit.create!(name: "3x in description", color: "red", description: "worm, worm, worm")
    Fruit.create!(name: "in color WEIGHT C", color: "worm brown", description: "large, round, yummy")
    Fruit.create!(name: "2x in color and description", color: "worm brown", description: "large, round, with a worm")

    assert_equal Fruit.search_by_all_human_readable_text("worm").map(&:name), ["3x in description",
                                                                               "2x in color and description",
                                                                               "worm in name WEIGHT A",
                                                                               "in description WEIGHT B",
                                                                               "in color WEIGHT C"]
  end
end
