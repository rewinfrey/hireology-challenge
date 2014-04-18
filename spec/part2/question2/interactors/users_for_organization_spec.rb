require 'spec_helper'
require 'part2/question2/interactors/interactors'

describe Interactors::UsersForOrganization do
  subject { Interactors.users_for_organization }

  it 'returns a collection of users and their roles for a given organization' do
    @org   = Factory.create_org
    @user1 = Factory.create_user
    @user2 = Factory.create_user
    @user3 = Factory.create_user
    @user_role   = Factory.create_role(type: "User", organization_id: @org.id, user_id: @user1.id)
    @admin_role  = Factory.create_role(type: "Admin", organization_id: @org.id, user_id: @user2.id)
    @denied_role = Factory.create_role(type: "Denied", organization_id: @org.id, user_id: @user3.id)

    subject.execute(@org.id).should == [{user: @user1, role: @user_role},
                                        {user: @user2, role: @admin_role},
                                        {user: @user3, role: @denied_role}]
  end
end
