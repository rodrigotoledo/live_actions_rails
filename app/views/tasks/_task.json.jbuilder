# frozen_string_literal: true

json.extract! task, :id, :title, :description, :scheduled_at, :completed, :created_at, :updated_at
json.url task_url(task, format: :json)
