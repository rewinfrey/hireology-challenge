module Interactors
  class RemoveOrganization
    def initialize(remove_organization, roles_for_organization, remove_role, remove_role_from_user)
      @remove_organization = remove_organization
      @roles_for_organization = roles_for_organization
      @remove_role = remove_role
      @remove_role_from_user = remove_role_from_user
    end

    def execute(org_id)
      remove_organization.execute(org_id)
      roles_for_organization.execute(org_id).each do |role|
        remove_role.execute(role.id)
        remove_role_from_user.execute(role.user_id, role.id)
      end
    end

    private

    attr_reader :remove_organization, :roles_for_organization, :remove_role, :remove_role_from_user
  end
end
