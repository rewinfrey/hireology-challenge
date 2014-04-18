require 'spec_helper'
require 'part2/question2/role/role'

describe Role::RolesForOrganization do
  subject { Role.roles_for_organization }

  it 'returns all roles associated with given organization' do
    org1  = Factory.create_org
    role1 = Factory.create_role(organization_id: org1.id)
    role2 = Factory.create_role(organization_id: org1.id)

    subject.execute(org1.id).should =~ [role1, role2]
  end
end
