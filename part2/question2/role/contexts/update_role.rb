module Role
  class UpdateRole
    class UserNotInOrganizationError < StandardError; end

    def initialize(repo, role_for_user_and_org)
      @repo = repo
      @role_for_user_and_org = role_for_user_and_org
    end

    def execute(user_id, org_id, role_type)
      if role = role_for_user_and_org.execute(user_id, org_id)
        repo.update(role.id, role_type)
      else
        raise UserNotInOrganizationError
      end
    end

    private

    attr_reader :repo, :role_for_user_and_org

    def user_role_for_org(user, org)
      repo.find_by_user_id(user.id).select do |role|
        role.organization_id == org.id
      end.first
    end
  end
end
