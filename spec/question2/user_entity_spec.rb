require 'spec_helper'
require 'part2/question2/entities/user'

describe Entities::User do
  let(:organizations) do
    [
      double(:root_organization, id: 1),
      double(:parent_organization, id: 2),
      double(:child_organization1, id: 3),
      double(:child_organization2, id: 4)
    ]
  end

  let(:roles) do
    [
      double(:role1, id:1, user_id: 1, organizations_id: 1, role: "User"),
      double(:role2, id:2, user_id: 1, organizations_id: 2, role: "Admin"),
      double(:role3, id:3, user_id: 1, organizations_id: 3, role: "Admin"),
      double(:role4, id:4, user_id: 1, organizations_id: 4, role: "Denied")
    ]
  end

  let(:user_entity_options) do
    {
      id: 1,
      name: "Test User",
      organizations: organizations,
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

  it 'has organizations' do
    subject.organizations.should == organizations
  end

  it 'has roles' do
    subject.roles.should == roles
  end
end
