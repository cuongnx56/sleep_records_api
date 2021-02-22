require 'grape_logging'

module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix :api
        version "v1", using: :path
        default_format :json
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        use GrapeLogging::Middleware::RequestLogger,
            instrumentation_key: 'grape_key',
            include: [GrapeLogging::Loggers::FilterParameters.new,
                      GrapeLogging::Loggers::RequestHeaders.new,
                      GrapeLogging::Loggers::RequestHeaders.new]

        helpers do
          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def logger
            Rails.logger
          end

          def current_user
            @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
          end

          def authenticate!
            error!('401 Unauthenticated', 401) unless current_user
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |exception|
          error_response(message: exception.message, status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |exception|
          error_response(message: exception.record.errors.full_messages, status: 422)
        end
      end
    end
  end
end
