class Task < ApplicationRecord
  after_create_commit do
    broadcast_prepend_to 'tasks', partial: 'tasks/task', locals: { task: self }
  end

  after_update_commit do
    broadcast_replace_to 'tasks', target: "task_#{id}", partial: 'tasks/task', locals: { task: self }
  end

  after_destroy do
    broadcast_remove_to 'tasks', target: "task_#{id}"
  end
end
