require 'spec_helper'
require 'part2/question2/organization/organization'

describe Organization::CreateOrganization do
  subject { Organization.create_organization }

  let(:org) {{ name: "Test Organization" }}

  it 'creates a new org whose parent is the root org' do
    org1 = subject.execute(org)

    org1.parent_id.should == Factory.org_repo.root.id
  end

  it 'creates a new org whose parent is a parent org' do
    parent1 = subject.execute(org)
    child1  = subject.execute(org.merge(parent_id: parent1.id))

    child1.parent_id.should == parent1.id
  end

  context 'errors' do
    it "raises error if new org's parent is a child org" do
      parent1 = subject.execute(org)
      child1  = subject.execute(org.merge(parent_id: parent1.id))

      expect { subject.execute(org.merge(parent_id: child1.id)) }.to raise_error Organization::Repository::ChildCannotBeParentError
    end

    it 'raises error if new org specifies a parent that does not exist' do
      expect { subject.execute(org.merge(parent_id: "invalid id")) }.to raise_error Organization::Repository::ParentRecordNotFoundError
    end

    it 'raises error if new org specifies an id that already exists' do
      org1 = subject.execute(org)

      expect { subject.execute(org.merge(id: org1.id)) }.to raise_error Organization::Repository::OrganizationAlreadyExistsError
    end
  end
end
