require 'part2/question2/organization/repository'
require 'part2/question2/organization/entity'
require 'part2/question2/organization/memory_model'
require 'part2/question2/organization/contexts/add_organization'
require 'part2/question2/role/role'
require 'part2/question2/user/user'

module Organization
  class << self
    def add_organization
      AddOrganization.new(repo)
    end

    def remove_organization
      RemoveOrganization.new(
        repo,
        role_repo,
        user_repo
      )
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

    def user_repo
      user.repo
    end

    def role_repo
      role.repo
    end

    def user
      User
    end

    def role
      Role
    end
  end
end
