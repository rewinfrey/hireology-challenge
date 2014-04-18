module Organization
  class Repository
    class NoRecordError < StandardError; end
    class ParentRecordNotFoundError < StandardError; end
    class OrganizationAlreadyExistsError < StandardError; end
    class ChildCannotBeParentError < StandardError; end

    def initialize(model, entity)
      @model  = model
      @entity = entity
    end

    def create(options)
      with_entity(
        model.create(options)
      )
    rescue model::ParentRecordNotFoundError => e
      raise ParentRecordNotFoundError, e.message
    rescue model::OrganizationAlreadyExistsError => e
      raise OrganizationAlreadyExistsError, e.message
    rescue model::ChildCannotBeParentError => e
      raise ChildCannotBeParentError, e.message
    end

    def delete!(org_id)
      model.delete!(org_id)
    end

    def delete_all!
      model.delete_all!
    end

    def all
      model.all.map { |org| with_entity(org) }
    end

    def find_by_id(org_id)
      with_entity(
        model.find_by_id(org_id)
      )
    rescue
      raise NoRecordError, "Organization with id: #{org_id} does not exist!"
    end

    def children_for(org)
      model.children_for(org.id).map do |child_id|
        find_by_id(child_id)
      end
    end

    def root
      with_entity(
        model.root
      )
    end

    private

    attr_reader :model, :entity

    def with_entity(org)
      entity.new(org)
    end
  end
end
