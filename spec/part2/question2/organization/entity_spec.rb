require 'spec_helper'
require 'part2/question2/organization/entity'

describe Organization::Entity do
  let(:organization_entity_options) do
    {
      id: 1,
      name: "Test Organization",
      parent_id: 0,
      children: []
    }
  end

  subject { described_class.new(organization_entity_options) }

  it 'has an id' do
    subject.id.should == 1
  end

  it 'has a name' do
    subject.name.should == "Test Organization"
  end

  it 'has a parent_id' do
    subject.parent_id.should == 0
  end

  it 'has children' do
    subject.children.should == []
  end
end
