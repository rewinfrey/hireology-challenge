require 'spec_helper'
require 'part2/question2/role/role'

describe Role::UpdateRole do
  subject { Role.update_role }

  it 'updates a user role for the given user, organization and role type' do
    org1  = Factory.create_org
    user1 = Factory.create_user(organizations: [org1.id])
    role1 = Factory.create_role(user_id: user1.id, organization_id: org1.id)
    Factory.add_role(user1, role1)

    role1.type.should == "User"

    subject.execute(user1.id, org1.id, "Admin")

    Factory.reload_role(role1).type.should == "Admin"
  end

  it 'raises error if the specified role type is not valid' do
    org1  = Factory.create_org
    user1 = Factory.create_user(organizations: [org1.id])
    role1 = Factory.create_role(user_id: user1.id, organization_id: org1.id)
    Factory.add_role(user1, role1)

    expect { subject.execute(user1.id, org1.id, "Invalid") }.to raise_error Role::Repository::InvalidRoleTypeError
  end

  it 'raises error if the given user does not have a role for the given organization' do
    org1 = Factory.create_org
    user1 = Factory.create_user(organizations: [])
    role1 = Factory.create_role(user_id: user1.id, organization_id: nil)
    Factory.add_role(user1, role1)

    expect { subject.execute(user1.id, org1.id, "Admin") }.to raise_error described_class::UserNotInOrganizationError
  end
end
