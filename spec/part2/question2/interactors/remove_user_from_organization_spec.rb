require 'spec_helper'
require 'part2/question2/interactors/interactors'

describe Interactors::RemoveUserFromOrganization do
  subject { Interactors.remove_user_from_organization }

  before(:each) do
    @org  = Factory.create_org
    @user = Factory.create_user
    @role = Factory.create_role(user_id: @user.id, organization_id: @org.id)
    Factory.add_role(@user, @role)
  end

  it 'removes the role for the given user and given organization' do
    subject.execute(@user.id, @org.id)

    Factory.role_repo.all.should_not include @role
  end

  it "removes the user's association to the role" do
    subject.execute(@user.id, @org.id)

    Factory.reload_user(@user).roles.should_not include @role.id
  end
end
