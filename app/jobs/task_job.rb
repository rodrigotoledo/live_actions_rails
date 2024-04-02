class TaskJob < ApplicationJob
  queue_as :default

  def perform(task)
    task.update(title: Faker::Lorem.sentence(word_count: 4), description: Faker::Lorem.paragraph)
  end
end
