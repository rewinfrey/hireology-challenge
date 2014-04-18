require 'spec_helper'
require 'part2/question2/interactors/interactors'

describe Interactors::RemoveUser do
  subject { Interactors.remove_user }

  before(:each) do
    user1 = Factory.create_user
    role1 = Factory.create_role(user_id: user1.id, organization_id: 1)
    Factory.add_role(user1, role1)

    subject.execute(Factory.reload_user(user1).id)
  end

  it 'removes the user from the user collection' do
    Factory.user_repo.all.size.should == 0
  end

  it 'removes any associated roles the user had' do
    Factory.role_repo.all.size.should == 0
  end
end
