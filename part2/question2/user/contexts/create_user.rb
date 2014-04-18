module User
  class CreateUser
    def initialize(user_repo)
      @user_repo = user_repo
    end

    def execute(options)
      user_repo.create(options)
    end

    private

    attr_reader :user_repo
  end
end
