# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do

  it { should validate_presence_of(:name) }
  it { should have_many(:task_categories).dependent(:destroy) }
  it { should have_many(:tasks).through(:task_categories) }
end
