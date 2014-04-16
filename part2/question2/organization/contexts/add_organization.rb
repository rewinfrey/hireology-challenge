module Organization
  class AddOrganization
    def initialize(repo)
      @repo = repo
    end

    def execute(options)
      repo.create(options)
    end

    private

    attr_reader :repo
  end
end
