module Entities
  class User < Struct.new(
                           :id,
                           :name,
                           :organizations
                         )

    def initialize(from_hash)
      super(*from_hash.values_at(*members))
    end
  end
end
