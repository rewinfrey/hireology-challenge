module Presenters
  class OrganizationsForUser
    def initialize(organizations_for_user, role_types)
      @organizations_for_user = organizations_for_user
      @role_types = role_types
    end

    def find_organizations(user_id)
      organizations(user_id)
    end

    def visible_organizations
      organizations.map do |org_role_hash|
        org_role_hash[:org] unless org_role_hash[:role].type == "Denied"
      end.compact
    end

    def all_organizations
      organizations.map do |org_role_hash|
        org_role_hash[:org]
      end
    end

    def admin_organizations
      organizations.map do |org_role_hash|
        org_role_hash[:org] if admin?(org_role_hash[:role])
      end.compact
    end

    def user_organizations
      organizations.map do |org_role_hash|
        org_role_hash[:org] if user?(org_role_hash[:role])
      end.compact
    end

    def denied_organizations
      organizations.map do |org_role_hash|
        org_role_hash[:org] if denied?(org_role_hash[:role])
      end.compact
    end

    private

    attr_reader :organizations_for_user, :role_types

    def organizations(user_id = nil)
      @organizations ||= organizations_for_user.execute(user_id)
    end

    def admin?(role)
      role.type == role_types::ADMIN
    end

    def user?(role)
      role.type == role_types::USER
    end

    def denied?(role)
      role.type == role_types::DENIED
    end
  end
end
