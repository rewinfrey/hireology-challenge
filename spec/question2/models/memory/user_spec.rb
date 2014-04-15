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

  it 'creates a new user record' do
    actual_user   = subject.create(user)
    expected_user = subject.all.last

    actual_user.should == expected_user
  end

  it 'deletes an existing record' do
    test_user = subject.create(user)
    subject.delete!(test_user[:id])

    subject.all.should be_empty
  end

  context '#all' do
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

  it 'finds a user by id' do
    test_user = subject.create(user)

    subject.find_by_id(test_user[:id]).should == test_user
  end

  it 'finds organizations by user id' do
    organization = double(:orgnanization)
    test_user = subject.create(user.merge(organizations: [organization]))

    subject.organizations_for(test_user[:id]).should == [organization]
  end

  it 'finds roles by user id' do
    role = double(:role)
    test_user = subject.create(user.merge(roles: [role]))

    subject.roles_for(test_user[:id]).should == [role]
  end
end
