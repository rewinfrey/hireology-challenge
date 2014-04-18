require 'spec_helper'
require 'part2/question2/organization/organization'

describe Organization::RemoveOrganization do
  subject { Organization.remove_organization }

  it 'removes the organization from the collection' do
    org1 = Factory.create_org

    subject.execute(org1.id)

    Organization.repo.all.should_not include org1
  end
end
