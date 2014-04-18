require 'spec_helper'
require 'part2/question2/role/role'

describe Role::RemoveRolesForUser do
  subject { Role.remove_roles_for_user }

  it 'removes all roles for the given user' do
    user1 = Factory.create_user
    role1 = Factory.create_role(user_id: user1.id, organization_id: 1)
    role2 = Factory.create_role(user_id: user1.id, organization_id: 2)

    subject.execute(user1.id)

    Factory.role_repo.all.size.should == 0
  end
end
