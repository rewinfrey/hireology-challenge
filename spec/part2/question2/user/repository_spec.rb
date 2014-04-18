require 'spec_helper'
require 'part2/question2/user/entity'
require 'part2/question2/user/memory_model'
require 'part2/question2/user/repository'

describe User::Repository do
  let(:model) { User::Memory::Model }
  let(:entity) { User::Entity }

  let(:user_options) {{ name: "Test User" }}

  subject { described_class.new(model, entity) }

  context 'create' do
    it 'creates a new user' do
      test_user = subject.create(user_options)

      test_user.id.should_not be_nil
      test_user.name.should == "Test User"
      test_user.roles.should be_empty
    end
  end

  context 'delete' do
    it 'deletes all users' do
      subject.create(user_options)
      subject.create(user_options)

      subject.all.size.should == 2

      subject.delete_all!

      subject.all.size.should == 0
    end

    it 'deletes a user' do
      test_user = subject.create(user_options)

      subject.delete!(test_user.id)

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

    it 'returns nil if the user does not exist' do
      subject.find_by_id(nil).should be_nil
    end

    it 'returns the roles for a given user' do
      test_user = subject.create(user_options)

      subject.roles_for(test_user.id).should == test_user.roles
    end
  end

  context 'roles' do
    it 'adds a role for a given user' do
      test_user = subject.create(user_options)

      test_user.roles.should == []

      updated_user = subject.add_role(test_user.id, 1)

      updated_user.roles.should == [1]
    end

    it 'removes a role for a given user' do
      test_user = subject.create(user_options.merge(roles: [1]))

      test_user.roles.should == [1]

      updated_user = subject.remove_role(test_user.id, 1)

      updated_user.roles.should be_empty
    end
  end
end
