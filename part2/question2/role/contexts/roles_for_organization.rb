module Role
  class RolesForOrganization
    def initialize(repo)
      @repo = repo
    end

    def execute(org_id)
      repo.find_by_organization_id(org_id)
    end

    private

    attr_reader :repo
  end
end
