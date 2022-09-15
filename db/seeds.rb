# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Fruit.delete_all
Vehicle.delete_all

apple_alpha = Fruit.create!(name: "apple", color: "red", description: "large, round, with a worm")
Fruit.create!(name: "apple", color: "green", description: "small, round")
Fruit.create!(name: "apple", color: "yellow", description: "small, sqauare")
Fruit.create!(name: "apple", color: "blue", description: "two bites, half a worm")
Fruit.create!(name: "apple", color: "purple", description: "has a bite out of it")

Fruit.create!(name: "bannana", color: "yellow", description: "yummy")
Fruit.create!(name: "bannana", color: "brown", description: "gross")
Fruit.create!(name: "bannana", color: "brown", description: "i dare you")

apple_alpha.vehicles << Vehicle.create(name: "blue dragon", description: "john's first car - blue minivan for band gear")
apple_alpha.vehicles << Vehicle.create(name: "green monster", description: "john's second car - roof was pulled out")



