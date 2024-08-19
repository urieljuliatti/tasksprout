# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::CommentsController', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user) }
  let!(:comment) { FactoryBot.create(:comment, task: task, user: user) }
  let(:token) do
    post '/login', params: { email: user.email, password: user.password }, as: :json
    JSON.parse(response.body)['token']
  end

  let(:headers) { { 'ACCEPT' => 'application/json', 'Authorization' => "Bearer #{token}" } }

  describe 'GET /tasks/:task_id/comments' do
    it 'returns comments for the task' do
      get "/api/v1/tasks/#{task.id}/comments", as: :json, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET /comments/:id' do
    it 'returns the comment' do
      get "/api/v1/comments/#{comment.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(comment.id)
    end

    it 'returns a 404 if the comment does not exist' do
      get '/api/v1/comments/0', headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /tasks/:task_id/comments' do
    let(:valid_attributes) { { content: 'This is a new comment' } }

    it 'creates a new comment' do
      expect {
        post api_v1_task_comments_path(task_id: task.id), params: { comment: valid_attributes }, headers: headers
      }.to change(Comment, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['content']).to eq('This is a new comment')
    end

    it 'returns a 422 if the comment is invalid' do
      post api_v1_task_comments_path(task_id: task.id), params: { comment: { content: '' } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH/PUT /comments/:id' do
    let(:valid_attributes) { { content: 'Updated comment' } }

    it 'updates the comment' do
      patch api_v1_comment_path(comment.id), params: { comment: valid_attributes }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(comment.reload.content).to eq('Updated comment')
    end

    it 'returns a 422 if the update is invalid' do
      patch api_v1_comment_path(comment.id), params: { comment: { content: '' } }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /comments/:id' do
    it 'deletes the comment' do
      expect {
        delete api_v1_comment_path(comment.id), headers: headers
      }.to change(Comment, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
