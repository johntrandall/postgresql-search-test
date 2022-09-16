class LegacyRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :legacy, reading: :legacy }
end
