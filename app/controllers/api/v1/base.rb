require 'grape'

module API
  module V1
    class Base < Grape::API
      mount API::V1::Clocks

      add_swagger_documentation(
        api_version: 'v1',
        hide_documentation_path: true,
        mount_path: '/api/v1/swagger_doc',
        hide_format: true,
        info: {
          title: 'API endpoint'
        }
      )
    end
  end
end
