require 'part2/question2/organization/repository'
require 'part2/question2/organization/entity'
require 'part2/question2/organization/memory_model'
require 'part2/question2/organization/contexts/create_organization'
require 'part2/question2/organization/contexts/remove_organization'

module Organization
  class << self
    def create_organization
      CreateOrganization.new(repo)
    end

    def remove_organization
      RemoveOrganization.new(repo)
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
