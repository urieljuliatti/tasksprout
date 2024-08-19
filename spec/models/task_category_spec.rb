# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskCategory, type: :model do

  it { should belong_to(:task) }
  it { should belong_to(:category) }
end
