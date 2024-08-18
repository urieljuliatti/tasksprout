class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :status, inclusion: { in: %w(pending in_progress completed) }
  validates :priority, inclusion: { in: %w(low medium high) }
end
