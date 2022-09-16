# == Schema Information
#
# Table name: super_heros
#
#  id            :bigint           not null, primary key
#  name          :string
#  superpower    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  fruit_id      :bigint
#  god_object_id :bigint
#  vehicle_id    :bigint
#
# Indexes
#
#  index_super_heros_on_fruit_id       (fruit_id)
#  index_super_heros_on_god_object_id  (god_object_id)
#  index_super_heros_on_vehicle_id     (vehicle_id)
#
require "test_helper"

class SuperHeroTest < ActiveSupport::TestCase
  test "can create" do
    SuperHero.create!(name: "Batman")
  end

  test "can create with vehicle- basic associations work across databases" do
    batman = SuperHero.create!(name: "Batman")
    batmobile = Vehicle.create!(name: "Batmobile")
    batman.update!(vehicle: batmobile)

    assert batman.vehicle, batmobile
    assert_includes batmobile.super_heroes, batman
  end

  test 'but no joins' do
    assert_raises ActiveRecord::StatementInvalid do
      puts SuperHero.joins(:vehicle).all
    end
  end

  test "#searchable (basic association) works same databases" do
    skip
  end

  test "#searchable (basic association) works across databases" do
    batman = SuperHero.create!(name: "Batman", superpower: 'money')
    wonder_woman = SuperHero.create!(name: "WonderWoman", superpower: 'strength of the amazon')
    aqua_man = SuperHero.create!(name: "AquaMan", superpower: 'breathes water')

    search_document = PgSearch.multisearch("water")

    assert_equal aqua_man, search_document.first.searchable
  end

  test "search works for single Model, when PGSearch Doc is in same database" do
    SuperHero.delete_all
    Vehicle.delete_all
    PgSearch::Document.delete_all

    batman = SuperHero.create!(name: "Batman", superpower: 'money')
    wonder_woman = SuperHero.create!(name: "WonderWoman", superpower: 'strength of the amazon')
    aqua_man = SuperHero.create!(name: "AquaMan", superpower: 'breathes water')

    batmobile = Vehicle.create!(name: "Batmobile")
    invisible_plane = Vehicle.create!(name: "Invisible Plane")

    batmobile.super_heroes << batman
    invisible_plane.super_heroes << [wonder_woman, aqua_man]

    search_documents = PgSearch.multisearch("Invisible")
    search_result_vehicles = Vehicle.where(id: search_documents.where(searchable_type: "Vehicle").select(:searchable_id))
    assert_equal [invisible_plane], search_result_vehicles
  end

  test "search works for single Model, when PGSearch Doc is in a different database" do
    SuperHero.delete_all
    Vehicle.delete_all
    PgSearch::Document.delete_all

    batman = SuperHero.create!(name: "Batman", superpower: 'money')
    wonder_woman = SuperHero.create!(name: "WonderWoman", superpower: 'strength of the amazon')
    aqua_man = SuperHero.create!(name: "AquaMan", superpower: 'breathes water')

    batmobile = Vehicle.create!(name: "Batmobile")
    invisible_plane = Vehicle.create!(name: "Invisible Plane")

    batmobile.super_heroes << batman
    invisible_plane.super_heroes << [wonder_woman, aqua_man]

    search_documents = PgSearch.multisearch("Batman")

    # have to pluck. ugh
    search_result_super_heroes = SuperHero.where(id: search_documents.where(searchable_type: "SuperHero").pluck(:searchable_id))
    assert_equal [batman], search_result_super_heroes

    # this doesn't work, need to use :disable_joins from rails 7
    # but - even if we have disable_joins, we are still plucking them all into memory. It might not be performant
    assert_raises ActiveRecord::StatementInvalid do
      search_result_super_heroes = SuperHero.where(id: search_documents.where(searchable_type: "SuperHero").select(:searchable_id))
      puts search_result_super_heroes
    end
  end
end
