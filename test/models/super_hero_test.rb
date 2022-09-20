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

  test "search works for a single Model, when, using a database query per associated record (NOT N+1)" do
    #SETUP
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

    page_num = 1
    pagination_count = 100
    # search_documents = PgSearch.multisearch("Batman")
    search_documents = PgSearch.multisearch("Batman").offset((page_num-1) * pagination_count).take(pagination_count)
    superhero_direct_hit = SuperHero.where(id: search_documents.select{|search_doc| search_doc.searchable_type == "SuperHero"}.map(&:searchable_id))
    superhero_vehicle_hit = SuperHero.where(id: search_documents.select{|search_doc| search_doc.searchable_type == "Vehicle"}.map(&:vehicle_superhero_id))

    # superhero_fruit_hit = SuperHero.where(id: search_documents.where(searchable_type: "Fruit").map(&:fruit_superhero_id))

    # services_direct_hit = Service.where(id: search_documents.where(searchable_type: "Service").map(&:service_id))
    # services_repository_hit = Service.where(id: search_documents.where(searchable_type: "Repository").map(&:repository_service_id))
    # services_team_hit = Service.where(id: search_documents.where(searchable_type: "Team").map(&:team_service_id))


    payload_of_models_for_serializer = search_documents.map do |search_doc|
      case search_doc.searchable_type
      when "SuperHero"
        superhero_direct_hit.select { id = search_doc.searchable_id }.first
      when "Vehicle"
        superhero_vehicle_hit.select { id = search_doc.superhero_vehicle_hit }.first
        # when "Fruit"
        #   services_team_hit.select{ id = search_doc.team_service_id}.first
        # end
      end
    end

    puts "payload_of_models_for_serializer"
    puts payload_of_models_for_serializer.to_s
  end
end


