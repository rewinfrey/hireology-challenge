require 'part2/question2/user/repository'
require 'part2/question2/user/memory_model'
require 'part2/question2/user/entity'

module User
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
