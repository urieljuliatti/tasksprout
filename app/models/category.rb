# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :task_categories, dependent: :destroy
  has_many :tasks, through: :task_categories
  validates :name, presence: true, uniqueness: true
end
