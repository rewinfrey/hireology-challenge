module Interactors
  class CreateOrganization
    def initialize(create_org, create_roles_for_organization, add_role_to_user)
      @create_org = create_org
      @create_roles_for_organization = create_roles_for_organization
      @add_role_to_user = add_role_to_user
    end

    def execute(options)
      create_org.execute(options).tap do |org|
        create_roles_for(org).each do |role|
          add_role_to_user.execute(role.user_id, role.id)
        end
      end
    end

    private

    attr_reader :create_org, :create_roles_for_organization, :add_role_to_user

    def create_roles_for(org)
      create_roles_for_organization.execute(org.id, org.parent_id)
    end
  end
end
