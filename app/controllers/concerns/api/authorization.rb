require 'doorkeeper/grape/helpers'

module API
  module Authorization
    extend ActiveSupport::Concern

    included do
      helpers Doorkeeper::Grape::Helpers

      before do
        doorkeeper_authorize!
      end
    end
  end
end
