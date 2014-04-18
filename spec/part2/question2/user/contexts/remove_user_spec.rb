require 'spec_helper'
require 'part2/question2/user/user'

describe User::RemoveUser do
  subject { User.remove_user }

  it 'removes a user from the collection' do
    user1 = Factory.create_user

    subject.execute(user1.id)

    Factory.user_repo.all.size.should == 0
  end
end
