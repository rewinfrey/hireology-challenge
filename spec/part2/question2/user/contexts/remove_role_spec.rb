require 'spec_helper'
require 'part2/question2/user/user'

describe User::RemoveRole do
  subject { User.remove_role }

  it 'disassociates the role from the user' do
    user = Factory.create_user
    role = Factory.create_role(user_id: user.id)

    subject.execute(user.id, role.id)

    Factory.reload_user(user).roles.should_not include role.id
  end
end
