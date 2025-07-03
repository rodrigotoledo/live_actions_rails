# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true

  after_create do
    broadcast_prepend_to "tasks", target: "tasks", partial: "tasks/task", locals: { task: self }
  end
  after_update do
    broadcast_update_to(
    "tasks",
    target: "task_#{id}",
    partial: "tasks/task",
    locals: { task: task }
  )
  end
end
