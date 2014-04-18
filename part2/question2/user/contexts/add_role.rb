module User
  class AddRole
    def initialize(repo)
      @repo = repo
    end

    def execute(user_id, role_id)
      repo.add_role(user_id, role_id)
    end

    private

    attr_reader :repo
  end
end
