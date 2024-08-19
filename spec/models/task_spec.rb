# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do

  it { should belong_to(:user) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:task_categories) }
  it { should have_many(:categories).through(:task_categories) }

  it { should validate_presence_of(:title) }
  it { should validate_inclusion_of(:status).in_array(%w(pending in_progress completed)) }
  it { should validate_inclusion_of(:priority).in_array(%w(low medium high)) }

  context 'when creating a task' do
    it 'is valid with valid attributes' do
      user = User.create!(email: 'user@example.com', password: 'password') # Cria um usuário para a associação
      task = Task.new(title: 'Test Task', status: 'pending', priority: 'medium', user: user)
      expect(task).to be_valid
    end

    it 'is not valid without a title' do
      task = Task.new(title: nil, status: 'pending', priority: 'medium')
      expect(task).not_to be_valid
    end

    it 'is not valid with an invalid status' do
      user = User.create!(email: 'user@example.com', password: 'password')
      task = Task.new(title: 'Test Task', status: 'invalid_status', priority: 'medium', user: user)
      expect(task).not_to be_valid
    end

    it 'is not valid with an invalid priority' do
      user = User.create!(email: 'user@example.com', password: 'password')
      task = Task.new(title: 'Test Task', status: 'pending', priority: 'invalid_priority', user: user)
      expect(task).not_to be_valid
    end
  end
end
