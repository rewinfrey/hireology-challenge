module Organization
  class RemoveOrganization
    def initialize(org_repo)
      @org_repo = org_repo
    end

    def execute(org_id)
      org_repo.delete!(org_id)
    end

    private

    attr_reader :org_repo
  end
end
