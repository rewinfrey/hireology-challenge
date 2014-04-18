module Role
  class RoleForUserAndOrganization
    def initialize(repo)
      @repo = repo
    end

    def execute(user_id, org_id)
      repo.find_by_user_id(user_id).select do |role|
        role.organization_id == org_id
      end.first
    end

    private

    attr_reader :repo
  end
end
