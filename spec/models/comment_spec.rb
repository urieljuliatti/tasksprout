
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  # Teste de associações
  it { should belong_to(:user) }
  it { should belong_to(:task) }

  # Teste de validação de conteúdo (caso seja necessário)
  it 'is valid with valid attributes' do
    user = FactoryBot.create(:user)
    task = FactoryBot.create(:task, user: user)
    comment = Comment.new(content: 'This is a test comment', user: user, task: task)

    expect(comment).to be_valid
  end

  it 'is not valid without a user' do
    task = FactoryBot.create(:task)
    comment = Comment.new(content: 'This is a test comment', user: nil, task: task)

    expect(comment).not_to be_valid
  end

  it 'is not valid without a task' do
    user = FactoryBot.create(:user)
    comment = Comment.new(content: 'This is a test comment', user: user, task: nil)

    expect(comment).not_to be_valid
  end

  it 'is not valid without content' do
    user = FactoryBot.create(:user)
    task = FactoryBot.create(:task, user: user)
    comment = Comment.new(content: nil, user: user, task: task)

    expect(comment).not_to be_valid
  end
end
