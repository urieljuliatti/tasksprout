# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api/v1/categories', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:categories) { create_list(:category, 5) }
  let(:category_id) { categories.first.id }
  let!(:task) { create(:task) } # Cria uma tarefa para testar a criação de categoria com tarefa
  let(:valid_attributes) { { name: 'New Category', user_id: user.id } }
  let(:invalid_attributes) { { name: '' } }
  let(:token) do
    post '/login', params: { email: 'admin2@example.com', password: '123456' }, as: :json
    JSON.parse(response.body)['token']
  end

  let(:headers) { { 'ACCEPT' => 'application/json', 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/categories' do
    before { get '/api/v1/categories', as: :json, headers: headers }

    it 'returns categories' do
      expect(response).to have_http_status(:success)
      expect(json.size).to eq(5)
    end
  end

  describe 'GET /api/v1/categories/:id' do
    before { get "/api/v1/categories/#{category_id}", as: :json, headers: headers }

    context 'when the record exists' do
      it 'returns the category' do
        expect(response).to have_http_status(:success)
        expect(json['id']).to eq(category_id)
      end
    end

    context 'when the record does not exist' do
      let(:category_id) { 0 }

      it 'returns a not found message' do
        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Not Found')
      end
    end
  end

  describe 'POST /api/v1/categories' do
    context 'with valid parameters' do
      before do
        post '/api/v1/categories', params: { category: valid_attributes, task_id: task.id }, as: :json, headers: headers
      end

      it 'creates a new category' do
        expect(response).to have_http_status(:created)
        expect(json['name']).to eq('New Category')
        #expect(TaskCategory.count).to eq(1)
      end
    end

    context 'with invalid parameters' do
      before do
        post '/api/v1/categories', params: { category: invalid_attributes, task_id: task.id }, as: :json, headers: headers
      end

      it 'does not create a new category' do
        expect(response).to have_http_status(422)
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /api/v1/categories/:id' do
    context 'with valid parameters' do
      before { put "/api/v1/categories/#{category_id}", params: { category: { name: 'Updated Category' } }, as: :json, headers: headers }

      it 'updates the category' do
        expect(response).to have_http_status(:success)
        expect(json['name']).to eq('Updated Category')
      end
    end

    context 'with invalid parameters' do
      before { put "/api/v1/categories/#{category_id}", params: { category: { name: '' } }, as: :json, headers: headers }

      it 'does not update the category' do
        expect(response).to have_http_status(422)
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'DELETE /api/v1/categories/:id' do
    before { delete "/api/v1/categories/#{category_id}", as: :json, headers: headers }

    it 'deletes the category' do
      expect(response).to have_http_status(:no_content)
      expect(Category.count).to eq(4)
    end
  end

  # Helper method to parse JSON response
  def json
    JSON.parse(response.body)
  end
end
