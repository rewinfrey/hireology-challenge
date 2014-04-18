require 'spec_helper'
require 'part2/question2/role/role'

describe Role::RoleForUserAndOrganization do
  subject { Role.role_for_user_and_organization }

  it 'returns the role for a given user and organization' do
    org1  = Factory.create_org
    user1 = Factory.create_user(organizations: [org1.id])
    role1 = Factory.create_role(user_id: user1.id, organization_id: org1.id)

    subject.execute(user1.id, org1.id).should == role1
  end
end
