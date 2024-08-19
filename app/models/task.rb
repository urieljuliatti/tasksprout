# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :task_categories
  has_many :categories, through: :task_categories
  validates :title, presence: true
  validates :status, inclusion: { in: %w(pending in_progress completed) }
  validates :priority, inclusion: { in: %w(low medium high) }
end
