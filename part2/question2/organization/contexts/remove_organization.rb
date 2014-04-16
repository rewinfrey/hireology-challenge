module Organization
  class RemoveOrganization
    def initialize(repo, role_repo, user_repo)
      @repo = repo
      @role_repo = role_repo
      @user_repo = user_repo
    end

    def execute(org)
      purge_organization(org)
      purge_users(org)
      purge_roles(org)
    end

    private

    def purge_organization(org)
      repo.delete!(org)
    end

    def purge_users(org)
      user_repo.find_by_organization_id(org.id).each do |user|
        user_repo.remove_organization(user.id, org.id)
      end
    end

    def purge_roles(org)
      role_repo.find_by_organization_id(org.id).each do |role|
        role_repo.delete!(role)
      end
    end

    attr_reader :repo, :role_repo, :user_repo
  end
end
