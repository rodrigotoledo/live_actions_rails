# frozen_string_literal: true

5.times.each do
  Task.create(title: Faker::Lorem.sentence(word_count: 4), description: Faker::Lorem.paragraph)
end
