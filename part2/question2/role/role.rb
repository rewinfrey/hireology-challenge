require 'part2/question2/role/contexts/create_role'
require 'part2/question2/role/contexts/create_roles_for_organization'
require 'part2/question2/role/contexts/remove_role'
require 'part2/question2/role/contexts/remove_roles_for_user'
require 'part2/question2/role/contexts/roles_for_organization'
require 'part2/question2/role/contexts/role_for_user_and_organization'
require 'part2/question2/role/contexts/update_role'
require 'part2/question2/role/memory_model'
require 'part2/question2/role/entity'
require 'part2/question2/role/repository'
require 'part2/question2/role/role_types'

module Role
  class << self
    def create_role
      CreateRole.new(repo)
    end

    def create_roles_for_organization
      CreateRolesForOrganization.new(
        repo,
        create_role
      )
    end

    def remove_role
      RemoveRole.new(repo)
    end

    def remove_roles_for_user
      RemoveRolesForUser.new(
        repo,
        remove_role
      )
    end

    def roles_for_organization
      RolesForOrganization.new(repo)
    end

    def update_role
      UpdateRole.new(
        repo,
        role_for_user_and_organization
      )
    end

    def role_for_user_and_organization
      RoleForUserAndOrganization.new(repo)
    end

    def repo
      Repository.new(
        model,
        entity
      )
    end

    def model
      Memory::Model
    end

    def entity
      Entity
    end

    def role_types
      RoleTypes
    end
  end
end

