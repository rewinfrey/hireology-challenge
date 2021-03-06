require 'spec_helper'
require 'part2/question2/role/entity'
require 'part2/question2/role/memory_model'
require 'part2/question2/role/repository'

describe Role::Repository do
  let(:model) { Role::Memory::Model }
  let(:entity) { Role::Entity }

  let(:role) do
    {
      type: "Admin",
      user_id: 1,
      organization_id: 1
    }
  end

  subject { described_class.new(model, entity) }

  context 'create' do
    it 'creates a new role' do
      test_role = subject.create(role)

      test_role.type.should == role[:type]
      test_role.user_id.should == role[:user_id]
      test_role.organization_id.should == role[:organization_id]
    end

    it 'raises error if the role type is invalid' do
      expect { subject.create(role.merge(type: "Invalid Type")) }.to raise_error described_class::InvalidRoleTypeError
    end

    it 'raises error if the specified id already exists' do
      role1 = subject.create(role)
      expect { subject.create(role.merge(id: role1.id)) }.to raise_error described_class::RoleAlreadyExistsError
    end
  end

  context 'all' do
    it 'returns all roles in the collection' do
      role1 = subject.create(role)
      role2 = subject.create(role)

      subject.all.should =~ [role1, role2]
    end
  end

  context 'update' do
    it 'updates an existing role' do
      role1 = subject.create(role.merge(type: "User"))

      subject.update(role1.id, "Admin")

      Factory.reload_role(role1).type.should == "Admin"
    end

    it 'raises an error if the type is invalid' do
      role1 = subject.create(role)

      expect { subject.update(role1, "Invalid") }.to raise_error described_class::InvalidRoleTypeError
    end
  end

  context 'delete' do
    it 'deletes all roles' do
      role1 = subject.create(role)
      role2 = subject.create(role)

      subject.delete_all!

      subject.all.should == []
    end

    it 'deletes a specified role' do
      role1 = subject.create(role)

      subject.delete!(role1.id)

      subject.all.should_not include role1
    end
  end

  context 'find' do
    it 'returns a role with a given id' do
      role1 = subject.create(role)

      subject.find_by_id(role1.id).should == role1
    end

    it 'returns nil if the role does not exist' do
      subject.find_by_id(nil).should be_nil
    end

    it 'returns all roles for a given user id' do
      role1 = subject.create(role.merge(user_id: 1))
      role2 = subject.create(role.merge(user_id: 1))
      role3 = subject.create(role.merge(user_id: 2))

      subject.find_by_user_id(role1.user_id).should =~ [role1, role2]
      subject.find_by_user_id(role1.user_id).should_not include role3
    end

    it 'returns all roles for a given organization id' do
      role1 = subject.create(role.merge(organization_id: 1))
      role2 = subject.create(role.merge(organization_id: 1))
      role3 = subject.create(role.merge(organization_id: 2))

      subject.find_by_organization_id(role1.organization_id).should =~ [role1, role2]
      subject.find_by_organization_id(role1.organization_id).should_not include role3
    end
  end
end
