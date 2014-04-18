require 'part2/question2/role/role_types'

module Role
  module Memory
    class Model
      class InvalidRoleTypeError < StandardError; end
      class RoleAlreadyExistsError < StandardError; end

      ADMIN   = RoleTypes::ADMIN
      USER    = RoleTypes::USER
      DENIED  = RoleTypes::DENIED
      DEFAULT = USER
      VALID_ROLES = [ADMIN, USER, DENIED]

      class << self
        def create(role_data)
          role_from(role_data).tap do |role|
            add_to_collection!(role)
          end
        end

        def all
          collection.compact
        end

        def delete!(role_id)
          collection[role_id] = nil
        end

        def delete_all!
          all.each { |role| delete! role[:id] }
        end

        def update(role_id, type)
          validate_role_type!(type)
          find_by_id(role_id).tap do |role|
            role[:type] = type
          end
        end

        def find_by_id(role_id)
          collection[role_id]
        end

        def find_by_user_id(user_id)
          all.select { |role| role[:user_id] == user_id }
        end

        def find_by_organization_id(org_id)
          all.select { |role| role[:organization_id] == org_id }
        end

        private

        def add_to_collection!(role)
          if collection[role[:id]].nil?
            collection[role[:id]] = role
          else
            raise RoleAlreadyExistsError, "Role with id: #{role[:id]} already exists!"
          end
        end

        def collection
          @collection ||= []
        end

        def role_from(role_data)
          {
            id: role_data.fetch(:id, next_id),
            type: validate_role_type!(role_data.fetch(:type, DEFAULT)),
            user_id: role_data.fetch(:user_id),
            organization_id: role_data.fetch(:organization_id)
          }
        end

        def next_id
          return 1 if collection_empty?
          collection.size
        end

        def collection_empty?
          collection.size == 0
        end

        def validate_role_type!(role_type)
          return role_type if VALID_ROLES.include? role_type
          raise InvalidRoleTypeError, "#{role_type} is not a valid role type"
        end
      end
    end
  end
end
