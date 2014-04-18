require 'part2/question2/interactors/interactors'
require 'part2/question2/presenters/organizations_for_user'

module Presenters
  class << self
    def organizations_for_user
      OrganizationsForUser.new(
        interactors.organizations_for_user,
        interactors.role_types
      )
    end

    def interactors
      Interactors
    end
  end
end
