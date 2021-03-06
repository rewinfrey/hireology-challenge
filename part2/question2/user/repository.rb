module User
  class Repository

    def initialize(model, entity)
      @model  = model
      @entity = entity
    end

    def create(options)
      with_entity(
        model.create(options)
      )
    end

    def delete!(user_id)
      model.delete!(user_id)
    end

    def delete_all!
      model.delete_all!
    end

    def find_by_id(user_id)
      with_entity(
        model.find_by_id(user_id)
      )
    rescue
    end

    def find_by_organization_id(org_id)
      model.find_by_organization_id(org_id).map { |user| with_entity user }
    end

    def organizations_for(user_id)
      model.organizations_for(user_id)
    end

    def roles_for(user_id)
      model.roles_for(user_id)
    end

    def all
      model.all.map { |user| entity.new(user) }
    end

    def add_organization(user_id, org_id)
      with_entity(
        model.add_organization(user_id, org_id)
      )
    end

    def remove_organization(user_id, organization_id)
      with_entity(
        model.remove_organization(user_id, organization_id)
      )
    end

    def add_role(user_id, role_id)
      with_entity(
        model.add_role(user_id, role_id)
      )
    end

    def remove_role(user_id, role_id)
      with_entity(
        model.remove_role(user_id, role_id)
      )
    end

    private

    attr_reader :model, :entity

    def with_entity(user)
      entity.new(user)
    end
  end
end
