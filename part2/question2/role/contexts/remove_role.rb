module Role
  class RemoveRole
    def initialize(repo)
      @repo = repo
    end

    def execute(role_id)
      repo.delete!(role_id)
    end

    private

    attr_reader :repo
  end
end
