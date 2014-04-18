require 'spec_helper'
require 'part2/question2/interactors/interactors'

describe Interactors::RemoveOrganization do
  subject { Interactors.remove_organization }

  it 'removes the specified organization from the organization collection' do
    test_org = Factory.create_org

    subject.execute(test_org.id)

    Factory.org_repo.all.should_not include test_org
  end

  it 'removes any roles associated with the organization from the role collection' do
    test_org  = Factory.create_org
    test_user = Factory.create_user
    test_role = Factory.create_role(user_id: test_user.id, organization_id: test_org.id)

    subject.execute(test_org.id)

    Factory.role_repo.all.should_not include test_role
  end

  it 'removes roles associated with the organization from its users' do
    test_org  = Factory.create_org
    test_user = Factory.create_user
    test_role = Factory.create_role(user_id: test_user.id, organization_id: test_org.id)
    Factory.add_role(test_user, test_role)

    subject.execute(test_org.id)

    Factory.reload_user(test_user).roles.should_not include test_role.id
  end
end
