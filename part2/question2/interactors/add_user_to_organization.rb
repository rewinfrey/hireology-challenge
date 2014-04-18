module Interactors
  class AddUserToOrganization
    def initialize(create_role, add_role_to_user)
      @create_role      = create_role
      @add_role_to_user = add_role_to_user
    end

    def execute(user_id, org_id)
      role = create_role.execute(role_data(user_id, org_id))
      add_role_to_user.execute(user_id, role.id)
    end

    private

    attr_reader :create_role, :add_role_to_user

    def role_data(user_id, org_id)
      {
        user_id: user_id,
        organization_id: org_id
      }
    end
  end
end
