require 'spec_helper'
require 'part2/question2/models/memory/user'

describe Models::Memory::User do
  subject { described_class }

  let(:user) do
    {
      name: "Test User",
      organizations: [],
      roles: []
    }
  end

  before(:each) do
    subject.all.each { |record| subject.delete!(record[:id]) }
  end

  context 'create' do
    it 'creates a new user record' do
      actual_user   = subject.create(user)
      expected_user = subject.all.last

      actual_user.should == expected_user
    end

    it 'creates a new user with a role' do
      role_ids = [1]
      test_user = subject.create(user.merge(roles: role_ids))
      test_user[:roles].should == role_ids
    end

    it 'creates a new user with an organization' do
      org_ids = [1]
      test_user = subject.create(user.merge(organizations: org_ids))
      test_user[:organizations].should == org_ids
    end

    it 'cannot create a user with an id that already exists' do
      test_user = subject.create(user)

      expect { subject.create(user.merge(id: test_user[:id])) }.to raise_error subject::UserAlreadyExistsError
    end
  end

  context 'delete' do
    it 'deletes an existing record' do
      test_user = subject.create(user)
      subject.delete!(test_user[:id])

      subject.all.should be_empty
    end

    it 'deletes all existing records' do
      subject.create(user)
      subject.create(user)

      subject.delete_all!
      subject.all.size.should == 0
    end
  end

  context 'all' do
    it 'returns an empty collection when no records exist' do
      subject.all.should == []
    end

    it 'returns one user when one user was created' do
      test_user = subject.create(user)

      subject.all.should == [test_user]
    end

    it 'returns users in the order they were added to the collection' do
      test_user1 = subject.create(user)
      test_user2 = subject.create(user)
      test_user3 = subject.create(user)

      subject.all.should == [test_user1, test_user2, test_user3]
    end
  end

  context 'find' do
    it 'finds a user by id' do
      test_user = subject.create(user)

      subject.find_by_id(test_user[:id]).should == test_user
    end

    it 'finds organizations by user id' do
      org_ids = [1]
      test_user = subject.create(user.merge(organizations: org_ids))

      subject.organizations_for(test_user[:id]).should == org_ids
    end

    it 'finds roles by user id' do
      role_ids = [1]
      test_user = subject.create(user.merge(roles: role_ids))

      subject.roles_for(test_user[:id]).should == role_ids
    end
  end

  context 'organizations' do

    it 'adds an organization to a user' do
      test_user = subject.create(user)
      new_org_id = 1

      subject.add_organization(test_user[:id], new_org_id)
      test_user[:organizations].should == [new_org_id]
    end

    it 'removes an organization from a user' do
      org_ids = [1]
      test_user = subject.create(user.merge(organizations: org_ids))

      subject.remove_organization(test_user[:id], org_ids.first)

      test_user[:organizations].size.should == 0
    end
  end

  context 'roles' do
    it 'adds a role to a user' do
      test_user = subject.create(user)
      new_role_id = 1

      subject.add_role(test_user[:id], new_role_id)
      test_user[:roles].should == [new_role_id]
    end

    it 'removes a role from a user' do
      role_ids = [1]
      test_user = subject.create(user.merge(roles: role_ids))

      subject.remove_role(test_user[:id], role_ids.first)

      test_user[:roles].size.should == 0
    end
  end
end
