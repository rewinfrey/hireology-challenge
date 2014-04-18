module Interactors
  class RemoveUserFromOrganization
    def initialize(remove_role, role_for_user_and_organization, remove_role_for_user)
      @remove_role = remove_role
      @role_for_user_and_organization = role_for_user_and_organization
      @remove_role_for_user = remove_role_for_user
    end

    def execute(user_id, org_id)
      if role = role_for_user_and_organization.execute(user_id, org_id)
        remove_role.execute(role.id)
        remove_role_for_user.execute(user_id, role.id)
      end
    end

    private

    attr_reader :remove_role, :role_for_user_and_organization, :remove_role_for_user
  end
end
