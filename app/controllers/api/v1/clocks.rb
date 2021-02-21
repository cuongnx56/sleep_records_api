module API
  module V1
    class Clocks < Grape::API
      include API::Defaults
      include API::Authorization

      resources :clocks do
        desc 'Get user clocked-in times',
              headers: {
                'Authorization' => {
                  description: 'Ex: Bearer [your_token]',
                  required: true
                }
              }

        params do
          optional :page, desc: 'Ex: 1'
        end

        get '/' do
          current_user.clocks.by_created_at_desc.page(permitted_params[:page])
        end

        desc 'Create clocked-in',
              headers: {
                'Authorization' => {
                  description: 'Ex: Bearer [your_token]',
                  required: true
                }
              }

        params do
          requires :action, desc: 'Ex: go_bed | wake_up'
        end

        post '/' do
          current_user.clocks.create action: permitted_params[:action]
        end
      end

    end
  end
end
