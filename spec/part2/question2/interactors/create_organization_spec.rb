require 'spec_helper'
require 'part2/question2/interactors/interactors'

describe Interactors::CreateOrganization do
  subject { Interactors.create_organization }

  let(:org)  {{ name: "Test Org" }}

  context 'create new parent organization' do
    it 'creates a new organization' do
      test_org = subject.execute(org)

      test_org.id.should_not be_nil
      test_org.name.should == org[:name]
      test_org.parent_id.should_not be_nil
      test_org.children.should == []
    end
  end

  context 'create new child organization' do
    before(:each) do
      @parent_org = Factory.create_org
      @user1 = Factory.create_user
      @user2 = Factory.create_user
      @parent_role_for_user1 = Factory.create_role(user_id: @user1.id, organization_id: @parent_org.id)
      @parent_role_for_user2 = Factory.create_role(user_id: @user2.id, organization_id: @parent_org.id)
      Factory.add_role(@user1, @parent_role_for_user1)
      Factory.add_role(@user2, @parent_role_for_user2)

      @child_org = subject.execute(org.merge(parent_id: @parent_org.id))

      @child_role_for_user1 = Factory.role_repo.find_by_id(@user1.roles.last)
      @child_role_for_user2 = Factory.role_repo.find_by_id(@user2.roles.last)
    end

    it 'associates the parent org to the child org' do
      @child_org.parent_id.should == @parent_org.id
    end

    it 'associates the child org to the parent org' do
      Factory.reload_org(@parent_org).children.should include @child_org.id
    end

    it 'creates new roles for every user associated with the parent org' do
      @user1.roles.should == [@parent_role_for_user1.id, @child_role_for_user1.id]
      @user2.roles.should == [@parent_role_for_user2.id, @child_role_for_user2.id]
    end

    it 'adds user association to new child role' do
      @child_role_for_user1.user_id.should == @user1.id
      @child_role_for_user2.user_id.should == @user2.id
    end

    it 'creates new roles for the child org based on the role types of the parent org' do
      @child_role_for_user1.type.should == @parent_role_for_user1.type
      @child_role_for_user2.type.should == @parent_role_for_user2.type
    end

    it 'associates child organization to the child roles' do
      @child_role_for_user1.organization_id.should == @child_org.id
      @child_role_for_user2.organization_id.should == @child_org.id
    end
  end

  context 'errors' do
    it 'raises error if new org specifies an existing child org as its parent' do
      parent_org = subject.execute(org)
      child_org  = subject.execute(org.merge(parent_id: parent_org.id))

      expect { subject.execute(org.merge(parent_id: child_org.id)) }.to raise_error Organization::Repository::ChildCannotBeParentError
    end

    it 'raises error if new org specifies an id that already exists' do
      org1 = subject.execute(org)

      expect { subject.execute(org.merge(id: org1.id)) }.to raise_error Organization::Repository::OrganizationAlreadyExistsError
    end

    it 'raises error if new org specifies a parent org that does not exist' do
      expect { subject.execute(org.merge(parent_id: "invalid id")) }.to raise_error Organization::Repository::ParentRecordNotFoundError
    end
  end
end
