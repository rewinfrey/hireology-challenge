module Organization
  module Memory
    class Model
      class ChildCannotBeParentError < StandardError; end
      class OrganizationAlreadyExistsError < StandardError; end
      class ParentRecordNotFoundError < StandardError; end

      class << self

        def create(org_data)
          org_from(org_data).tap do |org|
            add_as_child(org)
            add_to_collection!(org)
          end
        end

        def delete!(org_id)
          return if root?(org_id)
          find_by_id(org_id).tap do |org|
            purge_from_parent!(org)
            purge_children!(org)
            purge_from_collection!(org)
          end
        end

        def delete_all!
          all.each { |org| delete!(org[:id]) unless root?(org[:id]) }
        end

        def find_by_id(org_id)
          collection[org_id]
        rescue
        end

        def children_for(org_id)
          collection[org_id][:children]
        rescue
          []
        end

        def all
          collection.compact
        end

        def root
          root_org
        end

        private

        def collection
          @collection ||= []
        end

        def add_to_collection!(org)
          if collection[org[:id]].nil?
            collection[org[:id]] = org
          else
            raise OrganizationAlreadyExistsError, "The organization with id: #{org[:id]} already exists!"
          end
        end

        def add_as_child(org)
          find_by_id(org[:parent_id]).tap do |parent|
            if parent?(parent)
              add_child_to_parent(parent, org) if parent?(parent)
            else
              raise ChildCannotBeParentError, "A child organization cannot have children!"
            end
          end
        rescue NoMethodError
          raise ParentRecordNotFoundError, "Parent record with id: #{org[:parent_id]} cannot be found!"
        end

        def parent?(parent)
          return true if root?(parent[:id])
          find_by_id(parent[:parent_id]).tap do |second_parent|
            return root?(second_parent[:id])
          end
        end

        def add_parent_id_to_child_org(org_id, child_org_id)
          find_by_id(child_org_id).tap do |child|
            child[:parent_id] = org_id
          end
        end

        def add_child_to_parent(parent, child)
          parent[:children] << child[:id]
        end

        def purge_from_parent!(org)
          return unless org
          find_by_id(org[:parent_id]).tap do |parent|
            parent[:children] = parent[:children].reject { |child_org_id| child_org_id == org[:id] }
          end
        end

        def purge_children!(org)
          return unless org
          org[:children].each do |child_org_id|
            collection[child_org_id] = nil
          end
        end

        def purge_from_collection!(org)
          collection[org[:id]] = nil if org
        end

        def org_from(org_data)
          {
            parent_id: org_data.fetch(:parent_id, root_org[:id]),
            id: org_data.fetch(:id, next_id),
            name: org_data.fetch(:name, nil),
            children: org_data.fetch(:children, [])
          }
        end

        def next_id
          return collection.size + 1 if collection_empty?
          collection.size
        end

        def collection_empty?
          collection.size == 0
        end

        def root_org
          @root_org ||= create_root
        end

        def create_root
          add_to_collection!(root_data)
        end

        def root_data
          {
            id: 0,
            name: "Root",
            parent_id: nil,
            children: []
          }
        end

        def root?(org_id)
          root_data[:id] == org_id
        end
      end
    end
  end
end
