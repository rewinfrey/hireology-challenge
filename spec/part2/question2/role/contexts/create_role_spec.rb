require 'spec_helper'
require 'part2/question2/role/role'

describe Role::CreateRole do
  subject { Role.create_role }

  let(:role) {{ type: "Admin", user_id: 1, organization_id: 1 }}

  it 'creates a new role' do
    role1 = subject.execute(role)

    role1.id.should_not be_nil
    role1.type.should == role[:type]
    role1.user_id.should == role[:user_id]
    role1.organization_id.should == role[:organization_id]
  end

  it 'raises error if role type is invalid' do
    expect { subject.execute(role.merge(type: "Invalid")) }.to raise_error Role::Repository::InvalidRoleTypeError
  end

  it 'raises error if specified id already exists' do
    role1 = subject.execute(role)

    expect { subject.execute(role.merge(id: role1.id)) }.to raise_error Role::Repository::RoleAlreadyExistsError
  end
end
