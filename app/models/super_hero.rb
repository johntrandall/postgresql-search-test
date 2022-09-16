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
class SuperHero < LegacyRecord
  include PgSearch::Model

  belongs_to :vehicle, optional: true
  belongs_to :fruit, optional: true

  multisearchable(against: [:name, :superpower],
                  additional_attributes: -> (superhero) { { god_object_id: superhero.god_object_id,
                                                            super_hero_vehicle_id: superhero.vehicle_id,
                                                            fruit_id: superhero.fruit_id
                  } }
  )
end
