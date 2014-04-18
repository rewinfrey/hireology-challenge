require 'part2/question2/interactors/add_user_to_organization'
require 'part2/question2/interactors/create_organization'
require 'part2/question2/interactors/organizations_for_user'
require 'part2/question2/interactors/remove_organization'
require 'part2/question2/interactors/remove_user'
require 'part2/question2/interactors/remove_user_from_organization'
require 'part2/question2/interactors/users_for_organization'
require 'part2/question2/organization/organization'
require 'part2/question2/role/role'
require 'part2/question2/user/user'

module Interactors
  class << self
    def create_organization
      CreateOrganization.new(
        organization.create_organization,
        role.create_roles_for_organization,
        user.add_role
      )
    end

    def remove_organization
      RemoveOrganization.new(
        organization.remove_organization,
        role.roles_for_organization,
        role.remove_role,
        user.remove_role
      )
    end

    def add_user_to_organization
      AddUserToOrganization.new(
        role.create_role,
        user.add_role
      )
    end

    def organizations_for_user
      OrganizationsForUser.new(
        role.repo,
        organization.repo
      )
    end

    def users_for_organization
      UsersForOrganization.new(
        role.repo,
        user.repo
      )
    end

    def remove_user
      RemoveUser.new(
        user.remove_user,
        role.remove_roles_for_user
      )
    end

    def remove_user_from_organization
      RemoveUserFromOrganization.new(
        role.remove_role,
        role.role_for_user_and_organization,
        user.remove_role
      )
    end

    def role_types
      role.role_types
    end

    def organization
      Organization
    end

    def role
      Role
    end

    def user
      User
    end
  end
end
