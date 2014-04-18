require 'spec_helper'
require 'part2/question2/role/role'

describe Role::CreateRolesForOrganization do
  subject { Role.create_roles_for_organization }

  let(:role) {{ type: "Admin" }}

  context 'new org is a parent' do
    it 'does not add any new roles' do
      parent1 = Factory.create_org

      Role.repo.all.should == []

      subject.execute(parent1.id, parent1.parent_id)

      Role.repo.all.should == []
    end
  end

  context 'new org is a child' do
    before(:each) do
      @parent_org = Factory.create_org
      user1 = double(:user, id: 1)
      user2 = double(:user, id: 2)
      @parent_role_for_user1 = Factory.create_role(user_id: user1.id, organization_id: @parent_org.id)
      @parent_role_for_user2 = Factory.create_role(user_id: user2.id, organization_id: @parent_org.id)

      @child_org = Factory.create_org(parent_id: @parent_org.id)

      subject.execute(@child_org.id, @child_org.parent_id)

      @user1_roles = Factory.role_repo.find_by_user_id(user1.id)
      @user2_roles = Factory.role_repo.find_by_user_id(user2.id)
    end

    it 'creates new roles for the child org for each parent org user' do
      @user1_roles.size.should == 2
      @user2_roles.size.should == 2
      @user1_roles.last.organization_id.should == @child_org.id
      @user2_roles.last.organization_id.should == @child_org.id
    end

    it 'creates new roles for the child org based on the role types of the parent org' do
      @user1_roles.last.type.should == @parent_role_for_user1.type
      @user2_roles.last.type.should == @parent_role_for_user2.type
    end
  end
end
