require 'spec_helper'
require 'part2/question2/user/memory_model'

describe User::Memory::Model do
  subject { described_class }

  let(:user) do
    {
      name: "Test User",
      roles: []
    }
  end

  context 'create' do
    it 'creates a new user record' do
      test_user = subject.create(user)

      test_user[:id].should_not be_nil
      test_user[:name].should == user[:name]
      test_user[:roles].should be_empty
    end

    it 'creates a new user with a role' do
      roles = [1]
      test_user = subject.create(user.merge(roles: roles))

      test_user[:roles].should == roles
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

      subject.find_by_id(test_user[:id]).should be_nil
    end

    it 'deletes all existing records' do
      subject.create(user)
      subject.create(user)

      subject.delete_all!

      subject.all.should be_empty
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

    it 'finds roles by user id' do
      role_ids = [1]
      test_user = subject.create(user.merge(roles: role_ids))

      subject.roles_for(test_user[:id]).should == role_ids
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
