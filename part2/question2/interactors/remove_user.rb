module Interactors
  class RemoveUser
    def initialize(remove_user, remove_roles_for_user)
      @remove_user = remove_user
      @remove_roles_for_user = remove_roles_for_user
    end

    def execute(user_id)
      remove_roles_for_user.execute(user_id)
      remove_user.execute(user_id)
    end

    private

    attr_reader :remove_user, :remove_roles_for_user
  end
end
