require 'spec_helper'
require 'part2/question2/models/memory/organization'

describe Models::Memory::Organization do
  subject { described_class }

  let(:org) {{ name: "Test Organization" }}

  let(:child) {{ name: "Child Organization" }}

  before(:each) do
    subject.delete_all!
    subject.root[:children] = []
  end

  context 'create' do
    it 'creates a new organization' do
      test_org = subject.create(org)

      test_org[:id].should_not be_nil
      test_org[:name].should == org[:name]
      test_org[:parent_id].should_not be_nil
      test_org[:children].should be_empty
    end

    it "sets a new organization's parent to the root organization when no parent is specified" do
      test_org = subject.create(org)

      test_org[:parent_id].should == subject.root[:id]
    end

    it "sets a new organization's parent to the given parent organization when a parent is specified" do
      parent_org = subject.create(org)
      child_org  = subject.create(org.merge(parent_id: parent_org[:id]))

      child_org[:parent_id].should == parent_org[:id]
    end

    it "adds a new organization as a child to the root organization when no parent is specified" do
      test_org = subject.create(org)

      subject.root[:children].should == [test_org[:id]]
    end

    it "adds a new organization as a child to the given parent organization rather than the root" do
      parent_org = subject.create(org)
      child_org  = subject.create(child.merge(parent_id: parent_org[:id]))

      child_org[:parent_id].should == parent_org[:id]

      parent_org[:children].should include child_org[:id]
      subject.root[:children].should_not include child_org[:id]
    end

    it "a child organization cannot be a parent organization" do
      parent_org = subject.create(org)
      child_org = subject.create(child.merge(parent_id: parent_org[:id]))

      expect { subject.create(child.merge(parent_id: child_org[:id])) }.to raise_error subject::ChildCannotBeParentError
    end

    it 'cannot create an organization with an id that already exists' do
      test_org = subject.create(org)
      expect { subject.create(org.merge(id: test_org[:id])) }.to raise_error subject::OrganizationAlreadyExistsError
    end
  end

  context 'delete!' do
    it 'removes the organization from the collection' do
      test_org = subject.create(org)

      subject.delete!(test_org[:id])

      subject.find_by_id(test_org[:id]).should be_nil
    end

    it "removes the organization's children from the collection" do
      test_org   = subject.create(org)
      child_org1 = subject.create(child.merge(parent_id: test_org[:id]))
      child_org2 = subject.create(child.merge(parent_id: test_org[:id]))

      subject.delete!(test_org[:id])

      subject.find_by_id(test_org[:id]).should be_nil
      subject.find_by_id(child_org1[:id]).should be_nil
      subject.find_by_id(child_org2[:id]).should be_nil
    end

    it "removes the parent organization from the root's children" do
      test_org = subject.create(org)

      subject.delete!(test_org[:id])

      subject.root[:children].should_not include test_org[:id]
    end

    it "removes the child reference of an organization's parent" do
      test_org = subject.create(org)
      child_org = subject.create(child.merge(parent_id: test_org[:id]))

      subject.delete!(child_org[:id])

      test_org[:children].should_not include child_org[:id]
    end

    it "cannot delete the root organization" do
      subject.delete!(subject.root[:id]).should be_nil

      subject.root.should_not be_nil
    end
  end

  context 'delete_all!' do
    it 'removes all non-root organizations from the collection' do
      test_org1 = subject.create(org)
      test_org2 = subject.create(org)
      child_org1 = subject.create(child.merge(parent_id: test_org1[:id]))
      child_org2 = subject.create(child.merge(parent_id: test_org2[:id]))

      subject.all.size.should == 5

      subject.delete_all!

      subject.all.size.should == 1
      subject.all.first[:name].should == "Root"
    end
  end
end
