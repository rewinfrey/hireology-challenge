module User
  class RemoveRole
    def initialize(repo)
      @repo = repo
    end

    def execute(user_id, role_id)
      repo.remove_role(user_id, role_id)
    end

    private

    attr_reader :repo
  end
end
