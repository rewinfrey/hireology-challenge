require 'spec_helper'
require 'part2/question2/models/memory/role'

describe Models::Memory::Role do
  subject { described_class }

  let(:valid_role_types) { [subject::ADMIN, subject::USER, subject::DENIED] }

  let(:role) do
    {
      type: "Admin",
      user_id: 1,
      organization_id: 1
    }
  end

  before(:each) do
    subject.delete_all!
  end

  context 'create' do
    it 'creates a new role' do
      actual_role   = subject.create(role)
      expected_role = subject.all.last

      actual_role.should == expected_role
    end

    it 'errors when an invalid role type is created' do
      expect { subject.create(role.merge(type: "Invalid Role")) }.to raise_error subject::InvalidRoleTypeError
    end
  end

  context 'delete!' do
    it 'removes the specified role from the collection' do
      role1 = subject.create(role)

      subject.delete!(role1[:id])

      subject.all.should_not include role1
    end
  end

  context 'delete_all!' do
    it 'removes all roles from the collection' do
      role1 = subject.create(role)
      role2 = subject.create(role)

      subject.delete_all!

      subject.all.should == []
    end
  end

  context 'all' do
    it 'returns all roles in the collection' do
      role1 = subject.create(role)
      role2 = subject.create(role)

      subject.all.should =~ [role1, role2]
    end
  end

  context 'find' do
    it 'finds a role by id' do
      role1 = subject.create(role)

      subject.find_by_id(role1[:id]).should == role1
    end

    it 'finds all roles by user_id' do
      role1 = subject.create(role.merge(user_id: 0))
      role2 = subject.create(role.merge(user_id: 0))
      role3 = subject.create(role.merge(user_id: 1))

      subject.find_by_user_id(0).should =~ [role1, role2]
      subject.find_by_user_id(0).should_not include role3
    end

    it 'finds all roles by organization_id' do
      role1 = subject.create(role.merge(organization_id: 0))
      role2 = subject.create(role.merge(organization_id: 0))
      role3 = subject.create(role.merge(organization_id: 1))

      subject.find_by_organization_id(0).should =~ [role1, role2]
      subject.find_by_organization_id(0).should_not include role3
    end
  end
end
