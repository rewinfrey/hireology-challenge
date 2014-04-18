module Role
  class CreateRolesForOrganization
    def initialize(repo, create_role)
      @repo = repo
      @create_role = create_role
    end

    def execute(child_org_id, parent_org_id)
      repo.find_by_organization_id(parent_org_id).map do |parent_role|
        create_role.execute({
          type: parent_role.type,
          organization_id: child_org_id,
          user_id: parent_role.user_id
        })
      end
    end

    private

    attr_reader :repo, :create_role
  end
end
