require 'part2/question2/organization/organization'
require 'part2/question2/role/role'
require 'part2/question2/user/user'

class Factory
  class << self
    def user_repo
      User.repo
    end

    def org_repo
      Organization.repo
    end

    def role_repo
      Role.repo
    end

    def user
      { name: "Test User" }
    end

    def role
      { user_id: 1,
        organization_id: 1 }
    end

    def org
      { name: "Test Organization" }
    end

    def create_user(options = {name: "Test User"})
      user_repo.create(user.merge(options))
    end

    def create_role(options = {type: "User"})
      role_repo.create(role.merge(options))
    end

    def create_org(options = {name: "Test Organization"})
      org_repo.create(org.merge(options))
    end

    def add_role(user, role)
      user_repo.add_role(user.id, role.id)
    end

    def reload_user(test_user)
      user_repo.find_by_id(test_user.id)
    end

    def reload_role(test_role)
      role_repo.find_by_id(test_role.id)
    end

    def reload_org(test_org)
      org_repo.find_by_id(test_org.id)
    end

    def delete_all!
      org_repo.delete_all!
      role_repo.delete_all!
      user_repo.delete_all!
    end
  end
end
