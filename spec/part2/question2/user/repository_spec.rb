require 'spec_helper'
require 'part2/question2/user/entity'
require 'part2/question2/user/memory_model'
require 'part2/question2/user/repository'

describe User::Repository do
  let(:model) { User::Memory::Model }
  let(:entity) { User::Entity }

  let(:organizations) { [1,2,3,4] }

  let(:roles) { [1,2,3,4] }

  let(:user_options) do
    {
      name: "Test User",
      organizations: organizations,
      roles: roles
    }
  end

  before(:each) do
    subject.delete_all!
  end

  subject { described_class.new(model, entity) }

  context 'create' do
    it 'creates a new user' do
      test_user = subject.create(user_options)

      test_user.id.should_not be_nil
      test_user.name.should == "Test User"
      test_user.organizations.should == organizations
      test_user.roles.should == roles
    end
  end

  context 'delete' do
    it 'deletes all users' do
      subject.create(user_options)
      subject.create(user_options)

      subject.delete_all!

      subject.all.size.should == 0
    end

    it 'deletes a user' do
      test_user = subject.create(user_options)

      subject.delete!(test_user)

      subject.all.size.should == 0
    end
  end

  context 'all'do
    it 'returns all users' do
      user1 = subject.create(user_options)
      user2 = subject.create(user_options)

      subject.all.should =~ [user1, user2]
    end
  end

  context 'find' do
    it 'finds a user with a given id' do
      test_user = subject.create(user_options)

      subject.find_by_id(test_user.id).should == test_user
    end

    it 'raises a no record error if the user does not exist' do
      expect { subject.find_by_id(nil) }.to raise_error described_class::NoRecordError
    end

    it 'returns the organizations for a given user' do
      test_user = subject.create(user_options)

      subject.organizations_for(test_user.id).should == test_user.organizations
    end

    it 'returns the roles for a given user' do
      test_user = subject.create(user_options)

      subject.roles_for(test_user.id).should == test_user.roles
    end

    it 'returns the users for a given organization id' do
      user1 = subject.create(user_options.merge(organizations: [1]))
      user2 = subject.create(user_options.merge(organizations: [1]))
      user3 = subject.create(user_options.merge(organizations: [2]))

      subject.find_by_organization_id(1).should =~ [user1, user2]
      subject.find_by_organization_id(1).should_not include user3
    end
  end

  context 'organizations' do
    it 'adds an organization for a given user' do
      new_org_id = 5
      test_user = subject.create(user_options)

      test_user.organizations.should == [1,2,3,4]

      updated_user = subject.add_organization(test_user.id, new_org_id)

      updated_user.organizations.should == [1,2,3,4,5]
    end

    it 'removes an organization for a given user' do
      test_user = subject.create(user_options)

      test_user.organizations.should == [1,2,3,4]

      updated_user = subject.remove_organization(test_user.id, 4)

      updated_user.organizations.should == [1,2,3]
    end
  end

  context 'roles' do
    it 'adds a role for a given user' do
      new_role_id = 5
      test_user = subject.create(user_options)

      test_user.roles.should == [1,2,3,4]

      updated_user = subject.add_role(test_user.id, new_role_id)

      updated_user.roles.should == [1,2,3,4,5]
    end

    it 'removes a role for a given user' do
      test_user = subject.create(user_options)

      test_user.roles.should == [1,2,3,4]

      updated_user = subject.remove_role(test_user.id, 4)

      updated_user.roles.should == [1,2,3]
    end
  end
end
