module API
  module V1
    class Users < Grape::API
      include API::Authorization
      include API::V1::Defaults

      resources :users do
        desc 'Retrive all friends clocks times',
              headers: {
                'Authorization' => {
                  description: 'Ex: Bearer [your_token]',
                  required: true
                }
              }

        get '/friends_sleeps' do
          friend_ids = current_user.followers.pluck(:id)

          sql = """
                  SELECT user_id, go_bed_at, wake_up_at, (wake_up_at - go_bed_at)
                  AS time_sleep, created_at FROM clocks
                  WHERE user_id IN (#{friend_ids.join(', ')}) ORDER BY time_sleep DESC
                """
          rsp = ActiveRecord::Base.connection.execute(sql)
          rsp.present? ? rsp : []
        end

        desc 'Follow other user',
              headers: {
                'Authorization' => {
                  description: 'Ex: Bearer [your_token]',
                  required: true
                }
              }

        params do
          requires :user_id, desc: 'Ex: 2'
        end

        post '/follow/:user_id' do
          if current_user.following?(permitted_params[:user_id])
            { body: 'Already followed' }
          else
            current_user.follow!(permitted_params[:user_id])
            { body: 'Followed successful' }
          end
        end

        desc 'Unfollow other user',
              headers: {
                'Authorization' => {
                  description: 'Ex: Bearer [your_token]',
                  required: true
                }
              }

        params do
          requires :user_id, desc: 'Ex: 2'
        end

        post '/unfollow/:user_id' do
          if current_user.following?(permitted_params[:user_id])
            current_user.unfollow!(permitted_params[:user_id])
            { body: 'Unfollowed' }
          else
            { body: 'User not follow this user.' }
          end
        end
      end
    end
  end
end
