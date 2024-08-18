# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/login', type: :request do

  let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  describe 'POST /login' do
    let(:login_params) { { email: 'test@example.com', password: 'password123' } }

    context 'when the credentials are valid' do
      it 'returns a JWT token' do
        post '/login', params: login_params, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')

        json_response = JSON.parse(response.body)
        expect(json_response['token']).not_to be_nil
      end
    end

    context 'when the credentials are invalid' do
      it 'returns an unauthorized error' do
        invalid_params = { email: 'test@example.com', password: 'wrongpassword' }
        post '/login', params: invalid_params, as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to include('application/json')

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Invalid email or password')
      end

      it 'returns an unauthorized error if the email does not exist' do
        invalid_params = { email: 'nonexistent@example.com', password: 'password123' }
        post '/login', params: invalid_params, as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to include('application/json')

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Invalid email or password')
      end
    end
  end
end
