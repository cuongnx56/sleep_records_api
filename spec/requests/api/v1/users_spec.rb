require 'rails_helper'

describe "API::Users", :type => :request do
  let!(:user) { create(:user) }
  let(:default_headers) { { 'Authorization': 'Bearer invalid_token', 'Accept': 'application/json' } }
  let(:request_host) { 'http://localhost:3000' }

  describe 'Get all friends sleep records' do
    subject { get "#{request_host}#{uri}", headers: default_headers }

    let(:uri) { '/api/v1/users/friends_sleeps' }

    context 'when unauthorized' do
      it 'fails with HTTP 401' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:followed_user) { create(:user) }
      let(:token) { create(:access_token, resource_owner_id: user.id) }

      before do
        default_headers['Authorization'] = 'Bearer ' + token.token
        followed_user.follow!(user.id)
        create_list(:clock, 20, user: followed_user)
      end

      it 'returns all friends sleep records' do
        subject
        expect(JSON.parse(response.body).size).to eq(20)
      end

      it 'returns status code 200' do
        subject
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'Follow other user' do
    subject { post "#{request_host}#{uri}", headers: default_headers }

    let(:other_user) { create(:user) }
    let(:uri) { "/api/v1/users/follow/#{other_user.id}" }

    context 'when unauthorized' do
      it 'fails with HTTP 401' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:token) { create(:access_token, resource_owner_id: user.id) }

      before do
        default_headers['Authorization'] = 'Bearer ' + token.token
      end

      it 'follow other user' do
        subject
        expect(user.reload.following?(other_user).present?).to eq(true)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'Unfollow other user' do
    subject { post "#{request_host}#{uri}", headers: default_headers }

    let(:other_user) { create(:user) }
    let(:uri) { "/api/v1/users/unfollow/#{other_user.id}" }

    context 'when unauthorized' do
      it 'fails with HTTP 401' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:token) { create(:access_token, resource_owner_id: user.id) }

      before do
        default_headers['Authorization'] = 'Bearer ' + token.token
        user.follow!(other_user.id)
      end

      it 'unfollow other user' do
        subject
        expect(user.reload.following?(other_user).present?).to eq(false)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
