module Models
  module Memory
    class User
      class << self
        def create(user_data)
          add_to_collection!(
            user_from(user_data)
          )
        end

        def delete!(user_id)
          collection[user_id] = nil
        end

        def delete_all!
          all.each { |user| delete!(user[:id]) }
        end

        def find_by_id(user_id)
          collection[user_id]
        end

        def organizations_for(user_id)
          collection[user_id][:organizations]
        end

        def roles_for(user_id)
          collection[user_id][:roles]
        end

        def all
          collection.compact
        end

        def add_organization(user_id, org_id)
          find_by_id(user_id).tap do |user|
            user[:organizations] << org_id
            user
          end
        end

        def remove_organization(user_id, remove_org_id)
          find_by_id(user_id).tap do |user|
            user[:organizations] = user[:organizations].reject { |org_id| org_id == remove_org_id }
            user
          end
        end

        def add_role(user_id, role_id)
          find_by_id(user_id).tap do |user|
            user[:roles] << role_id
            user
          end
        end

        def remove_role(user_id, remove_role_id)
          find_by_id(user_id).tap do |user|
            user[:roles] = user[:roles].reject{ |role_id| role_id == remove_role_id }
            user
          end
        end

        private

        def collection
          @collection ||= []
        end

        def add_to_collection!(user)
          collection[user[:id]] = user
        end

        def user_from(user_data)
          {
            id: user_data.fetch(:id, next_id),
            name: user_data.fetch(:name, nil),
            organizations: user_data.fetch(:organizations, []),
            roles: user_data.fetch(:roles, [])
          }
        end

        def next_id
          return collection.size + 1 if collection.size == 0
          collection.size
        end
      end
    end
  end
end
