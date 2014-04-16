module Entities
  class Role < Struct.new(
                           :id,
                           :type,
                           :user_id,
                           :organization_id
                         )

    def initialize(from_hash)
      super(*from_hash.values_at(*members))
    end
  end
end
