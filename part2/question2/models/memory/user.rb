require 'hashie'

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
          collection.size + 1
        end
      end
    end
  end
end
