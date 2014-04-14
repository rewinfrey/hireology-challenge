module Entities
  class User < Struct.new(
                           :id,
                         )

    def initialize(from_hash)
      super(*from_hash.values_at(*members))
    end
  end
end
