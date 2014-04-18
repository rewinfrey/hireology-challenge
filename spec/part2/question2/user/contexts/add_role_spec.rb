require 'spec_helper'
require 'part2/question2/user/user'

describe User::AddRole do
  subject { User.add_role }

  it 'adds a role to a users roles' do
    org1  = Factory.create_org
    user1 = Factory.create_user
    role1 = Factory.create_role(user_id: user1.id, organization_id: org1.id)

    user1.roles.should be_empty

    subject.execute(user1.id, role1.id)

    Factory.reload_user(user1).roles.should include role1.id
  end
end
