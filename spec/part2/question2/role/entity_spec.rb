require 'spec_helper'
require 'part2/question2/role/entity'

describe Role::Entity do
  let(:role_entity_options) do
    {
      id: 1,
      type: "Admin",
      user_id: 1,
      organization_id: 1
    }
  end

  subject { described_class.new(role_entity_options) }

  it 'has an id' do
    subject.id.should == 1
  end

  it 'has a type' do
    subject.type.should == "Admin"
  end

  it 'has a user_id' do
    subject.user_id.should == 1
  end

  it 'has an organization_id' do
    subject.organization_id.should == 1
  end
end

