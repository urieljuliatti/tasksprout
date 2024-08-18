# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  # Teste para validar a presença do título
  it { should validate_presence_of(:title) }

  # Teste para validar a inclusão do status em um conjunto específico de valores
  it { should validate_inclusion_of(:status).in_array(%w(pending in_progress completed)) }

  # Teste para validar a inclusão da prioridade em um conjunto específico de valores
  it { should validate_inclusion_of(:priority).in_array(%w(low medium high)) }

  # Teste para verificar a associação com User
  it { should belong_to(:user) }
end
