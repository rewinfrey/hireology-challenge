require 'spec_helper'
require 'part2/question2/entities/organization'
require 'part2/question2/models/memory/organization'
require 'part2/question2/repositories/organization'

describe Repositories::Organization do
  let(:model) { Models::Memory::Organization }
  let(:entity) { Entities::Organization }

  let(:org) do
    {
      name: "Test Organization",
    }
  end

  subject { described_class.new(model, entity) }

  before(:each) do
    subject.delete_all!
  end

  context 'create' do
    it 'creates a new organization' do
      org1 = subject.create(org)

      org1.id.should_not be_nil
      org1.name.should == org[:name]
      org1.parent_id.should_not be_nil
      org1.children.should == []
    end
  end

  context 'all' do
    it 'returns all organizations' do
      org1 = subject.create(org)
      org2 = subject.create(org)
      root = subject.root

      subject.all.should =~ [root, org1, org2]
    end
  end

  context 'delete' do
    it 'deletes all organizations except for the root organization' do
      org1 = subject.create(org)
      org2 = subject.create(org)

      subject.delete_all!

      subject.all.should_not include org1
      subject.all.should_not include org2
    end

    it 'deletes an organization' do
      org1 = subject.create(org)

      subject.delete!(org1)

      subject.all.should_not include org1
    end
  end

  context 'find' do
    it 'finds an organization with a given id' do
      org1 = subject.create(org)

      subject.find_by_id(org1.id).should == org1
    end

    it 'returns all the children for a given parent organization' do
      org1 = subject.create(org)
      child1 = subject.create(org.merge(parent_id: org1.id))
      child2 = subject.create(org.merge(parent_id: org1.id))

      subject.children_for(org1).should =~ [child1, child2]
    end
  end
end
