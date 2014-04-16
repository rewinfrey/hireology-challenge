module Organization
  class Entity < Struct.new(
                             :id,
                             :name,
                             :parent_id,
                             :children
                           )

    def initialize(from_hash)
      super(*from_hash.values_at(*members))
    end
  end
end
