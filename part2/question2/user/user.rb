require 'part2/question2/user/contexts/add_role'
require 'part2/question2/user/contexts/create_user'
require 'part2/question2/user/contexts/remove_role'
require 'part2/question2/user/contexts/remove_user'
require 'part2/question2/user/entity'
require 'part2/question2/user/memory_model'
require 'part2/question2/user/repository'

module User
  class << self
    def create_user
      CreateUser.new(repo)
    end

    def add_role
      AddRole.new(repo)
    end

    def remove_role
      RemoveRole.new(repo)
    end

    def remove_user
      RemoveUser.new(repo)
    end

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
