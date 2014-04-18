module User
  class Entity < Struct.new(
                             :id,
                             :name,
                             :roles
                           )

    def initialize(from_hash)
      super(*from_hash.values_at(*members))
    end
  end
end
