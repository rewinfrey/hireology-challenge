require 'part2/question2/role/memory_model'
require 'part2/question2/role/entity'
require 'part2/question2/role/repository'

module Role
  class << self
    def repo
      Repository.new(model, entity)
    end

    def model
      Memory::Model
    end

    def entity
      Entity
    end
  end
end

