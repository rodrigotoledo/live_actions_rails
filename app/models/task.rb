# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true

  after_create_commit do
    broadcast_prepend_to 'tasks', target: 'tasks', partial: 'tasks/task', locals: { task: self }
  end
  broadcasts_refreshes
end
