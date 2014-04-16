module Repositories
  class Role
    class NoRecordError < StandardError; end

    def initialize(model, entity)
      @model  = model
      @entity = entity
    end

    def create(options)
      with_entity(
        model.create(options)
      )
    end

    def all
      model.all.map { |role| with_entity(role) }
    end

    def delete!(role)
      model.delete!(role.id)
    end

    def delete_all!
      model.delete_all!
    end

    def find_by_id(role_id)
      with_entity(
        model.find_by_id(role_id)
      )
    rescue
      raise NoRecordError, "Role with id: #{role_id} does not exist!"
    end

    def find_by_user_id(user_id)
      model.find_by_user_id(user_id).map { |role| with_entity(role) }
    end

    def find_by_organization_id(org_id)
      model.find_by_organization_id(org_id).map { |role| with_entity(role) }
    end

    private

    attr_reader :model, :entity

    def with_entity(role_data)
      entity.new(role_data)
    end
  end
end
