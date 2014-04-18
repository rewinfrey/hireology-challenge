require 'spec_helper'
require 'part2/question2/presenters/presenters'

describe Presenters::OrganizationsForUser do
  subject { Presenters.organizations_for_user }

  before(:each) do
    @org1 = Factory.create_org
    @org2 = Factory.create_org
    @org3 = Factory.create_org

    @user = Factory.create_user
    @user_role   = Factory.create_role(type: "User", organization_id: @org1.id, user_id: @user.id)
    @admin_role  = Factory.create_role(type: "Admin", organization_id: @org2.id, user_id: @user.id)
    @denied_role = Factory.create_role(type: "Denied", organization_id: @org3.id, user_id: @user.id)

    subject.find_organizations(@user.id)
  end

  context 'visible_organizations' do
    it "returns visible organizations for the given user" do
      subject.visible_organizations.should == [@org1, @org2]
    end
  end

  context 'all_organizations' do
    it "returns all organizations for the given user" do
      subject.all_organizations.should == [@org1, @org2, @org3]
    end
  end

  context 'admin_organizations' do
    it "returns only the organizations for which the user is an admin" do
      subject.admin_organizations.should == [@org2]
    end
  end

  context 'user_organizations' do
    it "returns only the organizations for which the user is a user" do
      subject.user_organizations.should == [@org1]
    end
  end

  context 'denied_organizations' do
    it "returns only the organizations for which the user is denied access" do
      subject.denied_organizations.should == [@org3]
    end
  end
end
