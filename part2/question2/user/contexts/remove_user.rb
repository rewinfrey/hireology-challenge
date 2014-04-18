module User
  class RemoveUser
    def initialize(repo)
      @repo = repo
    end

    def execute(user_id)
      repo.delete!(user_id)
    end

    private

    attr_reader :repo
  end
end
