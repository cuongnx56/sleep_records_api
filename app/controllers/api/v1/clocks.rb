module API
  module V1
    class Clocks < Grape::API
      include API::Authorization
      include API::V1::Defaults

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
          latest_clock = current_user.clocks.last

          case permitted_params[:action].to_s
          when 'go_bed'
            if latest_clock.blank? || latest_clock.wake_up?
              current_user.clocks.create(action: permitted_params[:action], go_bed_at: Time.zone.now)
            else
              latest_clock
            end
          when 'wake_up'
            if latest_clock.present? && latest_clock.go_bed?
              latest_clock.update(wake_up_at: Time.zone.now, action: permitted_params[:action])
            end

            latest_clock
          else
            {}
          end
        end
      end
    end
  end
end
