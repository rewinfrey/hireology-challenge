module Interactors
  class OrganizationsForUser
    def initialize(role_repo, organization_repo)
      @role_repo = role_repo
      @org_repo  = organization_repo
    end

    def execute(user_id)
      role_repo.find_by_user_id(user_id).reduce([]) do |collection, role|
        collection << { org: org_for_id(role.organization_id), role: role }
        collection
      end
    end

    private

    attr_reader :role_repo, :org_repo

    def org_for_id(org_id)
      org_repo.find_by_id(org_id)
    end
  end
end
