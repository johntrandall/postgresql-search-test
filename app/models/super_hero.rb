# == Schema Information
#
# Table name: super_heros
#
#  id         :bigint           not null, primary key
#  name       :string
#  superpower :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  vehicle_id :bigint
#
# Indexes
#
#  index_super_heros_on_vehicle_id  (vehicle_id)
#
class SuperHero < LegacyRecord
  
end
