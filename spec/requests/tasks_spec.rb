require 'rails_helper'

RSpec.describe 'Api::V1::TasksController', type: :request do
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }
  let(:valid_attributes) { { title: 'New Task', description: 'Task description', status: 'pending', priority: 'low', due_date: '2024-12-31' , user_id: user.id} }
  let(:invalid_attributes) { { title: '', status: 'invalid_status' } }

  describe 'GET /tasks' do
    it 'returns a list of tasks' do
      get api_v1_tasks_url, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end
  end

  describe 'GET /tasks/:id' do
    it 'returns the task' do
      get "/api/v1/tasks/#{task.id}", as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(task.id)
    end
  end

  describe 'POST /tasks' do
    context 'with valid parameters' do
      it 'creates a new task' do
        post api_v1_tasks_url, params: { task: attributes_for(:task), user_id: user.id }, as: :json

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['title']).to eq('New Task')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error' do
        post api_v1_tasks_url, params: { task: invalid_attributes }, as: :json
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PATCH/PUT /tasks/:id' do
    context 'with valid parameters' do
      it 'updates the task' do
        patch "/api/v1/tasks/#{task.id}", params: { task: { title: 'Updated Task' } }, as: :json

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['title']).to eq('Updated Task')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error' do
        patch "/api/v1/tasks/#{task.id}", params: { task: { title: '' } }, as: :json

        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /tasks/:id' do
    it 'deletes the task' do
      delete "/api/v1/tasks/#{task.id}", as: :json

      expect(response).to have_http_status(:no_content)
      expect(Task.exists?(task.id)).to be_falsey
    end
  end
end
