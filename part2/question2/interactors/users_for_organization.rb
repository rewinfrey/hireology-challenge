module Interactors
  class UsersForOrganization
    def initialize(role_repo, user_repo)
      @role_repo = role_repo
      @user_repo = user_repo
    end

    def execute(org_id)
      @role_repo.find_by_organization_id(org_id).reduce([]) do |collection, role|
        collection << { user: user_for_id(role.user_id), role: role }
        collection
      end
    end

    private

    attr_reader :role_repo, :user_repo

    def user_for_id(user_id)
      user_repo.find_by_id(user_id)
    end
  end
end
