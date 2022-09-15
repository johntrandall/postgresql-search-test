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



  test "multisearch, basic" do
    multi_search_setup

    results_search_documents = PgSearch.multisearch("blue")
    results_records = results_search_documents.map(&:searchable)

    puts "\n\n\n results_search_documents"
    pp results_search_documents
    puts "\n\n\n results_records"
    pp results_records.group_by { |record| record.class.name.to_sym }

    # these show up in order by model (fruit first), then by order of creation
    assert_equal ["apple_blue", "apple_sky_blue", "blue_dragon", "green_monster"], results_records.map(&:name)
  end

  test "multisearch, search for fruit, but include data from associated records, across records" do
    multi_search_setup

    # just one trip to the database
    results_search_documents = PgSearch.multisearch("blue")


    # FRUIT MATCH ON SELF
    pg_search_documents = results_search_documents.where(searchable_type: Fruit.name)
    records = Fruit.joins(:pg_search_document).where(pg_search_document:{id:pg_search_documents})
    assert_equal ["apple_blue", "apple_sky_blue"], records.map(&:name)


    # VEHICLE MATCH ON SELF
    pg_search_documents = results_search_documents.where(searchable_type: Vehicle.name)
    records = Vehicle.joins(:pg_search_document).where(pg_search_document:{id:pg_search_documents})
    assert_equal ["blue_dragon", "green_monster"], records.map(&:name)


    # FRUIT MATCH ON ASSOCIATED VEHICLE
    # This is just a single database query
    # Fruit Load (2.0ms)  SELECT DISTINCT "fruits".* FROM "fruits" INNER JOIN "vehicles" ON "vehicles"."fruit_id" = "fruits"."id" WHERE "vehicles"."id" IN (SELECT "vehicles"."id" FROM "vehicles" INNER JOIN "pg_search_documents" "pg_search_document" ON "pg_search_document"."searchable_type" = $1 AND "pg_search_document"."searchable_id" = "vehicles"."id" WHERE "pg_search_document"."id" IN (SELECT "pg_search_documents"."id" FROM "pg_search_documents" INNER JOIN (SELECT "pg_search_documents"."id" AS pg_search_id, (ts_rank((to_tsvector('simple', coalesce("pg_search_documents"."content"::text, ''))), (to_tsquery('simple', ''' ' || 'blue' || ' ''')), 0)) AS rank FROM "pg_search_documents" WHERE ((to_tsvector('simple', coalesce("pg_search_documents"."content"::text, ''))) @@ (to_tsquery('simple', ''' ' || 'blue' || ' ''')))) AS pg_search_ce9b9dd18c5c0023f2116f ON "pg_search_documents"."id" = pg_search_ce9b9dd18c5c0023f2116f.pg_search_id WHERE "pg_search_documents"."searchable_type" = $2 ORDER BY pg_search_ce9b9dd18c5c0023f2116f.rank DESC, "pg_search_documents"."id" ASC))  [["searchable_type", "Vehicle"], ["searchable_type", "Vehicle"]]
    pg_search_documents = results_search_documents.where(searchable_type: Vehicle.name)
    associated_vehicle_records = Vehicle.joins(:pg_search_document).where(pg_search_document:{id:pg_search_documents})
    records = Fruit.joins(:vehicles).where(vehicles:{id:associated_vehicle_records}).distinct
    assert_equal ["apple_alpha_has_vehicles"], records.map(&:name)
  end

  def multi_search_setup
    apple_alpha_has_vehicles = Fruit.create!(name: "apple_alpha_has_vehicles", color: "red", description: "large, round, with a worm")
    apple_blue = Fruit.create!(name: "apple_blue", color: "blue", description: "two bites, half a worm")

    Fruit.create!(name: "apple", color: "green", description: "small, round")
    Fruit.create!(name: "apple", color: "yellow", description: "small, sqauare")
    Fruit.create!(name: "apple", color: "purple", description: "has a bite out of it")
    Fruit.create!(name: "bannana", color: "yellow", description: "yummy")
    Fruit.create!(name: "bannana", color: "brown", description: "gross")
    Fruit.create!(name: "bannana", color: "brown", description: "i dare you")

    boring_subaru = Vehicle.create(name: "boring_subaru", description: "john's becomes a dad", wheel_description: 'cannot remember')
    blue_dragon = Vehicle.create(name: "blue_dragon", description: "john's first car - blue minivan for band gear", wheel_description: 'awesome, with skulls')
    green_monster = Vehicle.create(name: "green_monster", description: "john's second car - roof was pulled out", wheel_description: 'retro, with whitewalls, but they got stained blue')

    apple_sky_blue = Fruit.create!(name: "apple_sky_blue", color: "blue", description: "two bites, half a worm")

    apple_alpha_has_vehicles.vehicles << blue_dragon
    apple_alpha_has_vehicles.vehicles << green_monster
  end

end
