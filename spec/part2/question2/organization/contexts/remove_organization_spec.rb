require 'spec_helper'
require 'part2/question2/organization/contexts/remove_organization'
require 'part2/question2/organization/organization'
require 'part2/question2/user/user'
require 'part2/question2/role/role'

describe Organization::RemoveOrganization do
  subject { Organization.remove_organization }

  let(:org) {{ name: "Test Organization" }}
  let(:user) {{ name: "Test User" }}
  let(:role) {{ type: "Admin" }}

  def create_user(options)
    User.repo.create(user.merge(options))
  end

  def reload_user(test_user)
    User.repo.find_by_id(test_user.id)
  end

  it 'removes the specified organization from the organization collection' do
    test_org = Organization.repo.create(org)
    subject.execute(test_org)
    Organization.repo.all.should_not include test_org
    User.repo.create(user.merge(organizations: [test_org.id]))
  end

  it 'removes the organization from any associated user' do
    test_org = Organization.repo.create(org)
    test_user = create_user(organizations: [test_org.id])

    subject.execute(test_org)

    refreshed_user = User.repo.find_by_id(test_user.id)
    refreshed_user.organizations.should_not include test_org.id
  end

  it 'removes any roles associated with the organization' do
    test_org = Organization.repo.create(org)
    test_user = User.repo.create(user.merge(organizations: [test_org.id]))
    test_role = Role.repo.create(role.merge(user_id: test_user.id, organization_id: test_org.id))

    subject.execute(test_org)

    Role.repo.all.should_not include test_role
  end
end
