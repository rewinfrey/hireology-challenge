require 'spec_helper'
require 'part2/question2/interactors/interactors'

describe Interactors::OrganizationsForUser do
  subject { Interactors.organizations_for_user }

  it 'returns organization entities with the corresponding role' do
    @org1 = Factory.create_org
    @org2 = Factory.create_org
    @org3 = Factory.create_org

    @user = Factory.create_user
    @user_role   = Factory.create_role(type: "User", organization_id: @org1.id, user_id: @user.id)
    @admin_role  = Factory.create_role(type: "Admin", organization_id: @org2.id, user_id: @user.id)
    @denied_role = Factory.create_role(type: "Denied", organization_id: @org3.id, user_id: @user.id)

    subject.execute(@user.id).should == [{org: @org1, role: @user_role},
                                         {org: @org2, role: @admin_role},
                                         {org: @org3, role: @denied_role}]
  end
end
