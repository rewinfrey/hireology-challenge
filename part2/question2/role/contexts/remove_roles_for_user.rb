module Role
  class RemoveRolesForUser
    def initialize(repo, remove_role)
      @repo = repo
      @remove_role = remove_role
    end

    def execute(user_id)
      repo.find_by_user_id(user_id).each do |role|
        remove_role.execute(role.id)
      end
    end

    private

    attr_reader :repo, :remove_role
  end
end
