require 'spec_helper'
require 'part2/question2/organization/contexts/add_organization'
require 'part2/question2/organization/organization'

describe Organization::AddOrganization do
  subject { Organization.add_organization }

  let(:org) {{ name: "Test Organization" }}

  it 'creates a new organization' do
    test_org = subject.execute(org)

    test_org.id.should_not be_nil
    test_org.name.should == org[:name]
    test_org.parent_id.should_not be_nil
    test_org.children.should == []
  end
end
