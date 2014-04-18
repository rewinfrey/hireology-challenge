require 'spec_helper'
require 'part2/question2/role/role'

describe Role::RemoveRole do
  subject { Role.remove_role }

  it 'removes the role from the collection' do
    role1 = Factory.create_role

    subject.execute(role1.id)

    Role.repo.all.should_not include role1
  end
end
