require 'spec_helper'
require 'part2/question2/interactors/interactors'

describe Interactors::AddUserToOrganization do
  subject { Interactors.add_user_to_organization }

  it 'associates an organization to a user' do
    user = Factory.create_user
    organization = Factory.create_org

    subject.execute(user.id, organization.id)

    updated_user = Factory.reload_user(user)
  end

  it 'creates the default role for the user and the organization' do
    user = Factory.create_user
    organization = Factory.create_org

    subject.execute(user.id, organization.id)

    new_role = Factory.role_repo.find_by_user_id(user.id).first

    new_role.organization_id.should == organization.id
    new_role.type.should == "User"
  end
end
