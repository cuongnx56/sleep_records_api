require 'rails_helper'

describe "API::Clocks", :type => :request do
  let!(:user) { create(:user) }
  let(:default_headers) { { 'Authorization': 'Bearer invalid_token', 'Accept': 'application/json' } }
  let(:request_host) { 'http://localhost:3000' }

  describe 'Get all users clocks records' do
    subject { get "#{request_host}#{uri}", headers: default_headers }

    let(:uri) { '/api/v1/clocks' }

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
        create_list(:clock, 20, user: user)
      end

      it 'returns all user sleep records' do
        subject
        expect(JSON.parse(response.body).size).to eq(20)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'Create clock record' do
    subject { post "#{request_host}#{uri}", params: params, headers: default_headers }

    let(:uri) { "/api/v1/clocks" }
    let(:params) { {} }

    context 'when unauthorized' do
      it 'fails with HTTP 401' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:token) { create(:access_token, resource_owner_id: user.id) }

      context 'when first time create clock in' do
        before do
          default_headers['Authorization'] = 'Bearer ' + token.token
          params['action'] = 'go_bed'
        end

        it 'create user clock go_bed record' do
          subject
          expect(user.reload.clocks.last.go_bed?).to eq(true)
          expect(response).to have_http_status(:success)
        end
      end

      context 'when user sleep already' do
        let!(:clock) { create(:clock, user: user, action: 'go_bed') }

        before do
          default_headers['Authorization'] = 'Bearer ' + token.token
        end

        context 'post params is go_bed action' do
          before { params['action'] = 'go_bed' }

          it do
            subject
            expect(clock.reload.go_bed?).to eq(true)
            expect(response).to have_http_status(:success)
          end
        end

        context 'post params action to wake_up' do
          before { params['action'] = 'wake_up' }

          it do
            subject
            expect(clock.reload.wake_up?).to eq(true)
            expect(response).to have_http_status(:success)
          end
        end
      end

      context 'when user wake_up already' do
        let!(:clock) { create(:clock, user: user, action: 'wake_up') }

        before do
          default_headers['Authorization'] = 'Bearer ' + token.token
        end

        context 'post params is go_bed action' do
          before { params['action'] = 'go_bed' }

          it do
            subject
            expect(clock.reload.wake_up?).to eq(true)
            expect(user.reload.clocks.last.go_bed?).to eq(true)
            expect(response).to have_http_status(:success)
          end
        end

        context 'post params action to wake_up' do
          before { params['action'] = 'wake_up' }

          it do
            subject
            expect(clock.reload.wake_up?).to eq(true)
            expect(user.reload.clocks.last.go_bed?).to eq(false)
            expect(response).to have_http_status(:success)
          end
        end
      end
    end
  end
end
