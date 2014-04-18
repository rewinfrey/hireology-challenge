require 'spec_helper'
require 'part2/question2/user/entity'

describe User::Entity do
  let(:roles) do
    [
      double(:role1, id:1, user_id: 1, organization_id: 1, role: "User"),
      double(:role2, id:2, user_id: 1, organization_id: 2, role: "Admin"),
      double(:role3, id:3, user_id: 1, organization_id: 3, role: "Admin"),
      double(:role4, id:4, user_id: 1, organization_id: 4, role: "Denied")
    ]
  end

  let(:user_entity_options) do
    {
      id: 1,
      name: "Test User",
      roles: roles
    }
  end

  subject { described_class.new(user_entity_options) }

  it 'has an id' do
    subject.id.should == 1
  end

  it 'has a name' do
    subject.name.should == "Test User"
  end

  it 'has roles' do
    subject.roles.should == roles
  end
end
