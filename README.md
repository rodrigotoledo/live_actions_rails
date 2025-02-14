# Course: Ruby on Rails Application Development with Time Events

## Introduction

Presentation of the course and objectives.

## Module 1: Development Environment Configuration with Ruby on Rails 7.x

1. Installation of Ruby on Rails 7.x
- Initial configuration of the Rails Project.
- Applying Framework with TailWindcss
- Installing Gem `Foreman` that helps manage background processes

```bash
gem install rails --no-doc
rails new live_actions
cd live_actions
bundle add tailwindcss-rails
bundle install
rails tailwindcss:install
gem install foreman
code .
```

## Module 2: Application Development

1. Implementation of task control
- Creating Task Screen
- Use of Gem `Faker` and Seeds
- Accessing the application.

```bash
rails g scaffold Task title description:text scheduled_at:datetime completed:boolean
bundle add faker
bundle install
```

```ruby
# db/seeds.rb
5.times.each do
  Task.create(title: Faker::Lorem.sentence(word_count: 4), description: Faker::Lorem.paragraph)
end
```

Creating and populating with data for development

```bash
rails db:drop db:create db:migrate db:seed
```

Correct the initial route

```ruby
# config/routes.rb
root "tasks#index"
```

And starting the application to access<http://localhost:3000>

```bash
bin/dev
```

Improving `Scheduled_at`

`app/views/tasks/_task.html.erb`

```erb
<%= I18n.l(task.scheduled_at, format: :long) if task.scheduled_at.present?  %>
```

## Module 3: Real -time record update with Hotwire

1. Hotwire and the concept of record update
- The concept of Broadcasting (refers to the ability to send real-time information to several connected clients simultaneous)
- The concept of turbo-fumes (allows to update specific parts of a web page without recharging the entire page)
- In short, while Broadcasting is used to send real -time information to multiple customers, turbo frames are used to update specific parts of a web page without recharging the entire page, providing a faster and responsive user experience
- Updating the list when creating, editing or removing task records
- Redis (it is an open source memory database that is used as a data structure, cache and messaging)


```bash
bundle add turbo-rails
bundle install
rails turbo:install
rails turbo:install:redis
```

```ruby
# app/models/task.rb
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
```

Making the list possible to receive updates

`app/views/tasks/index.html.erb`

```erb
<%=turbo_stream_from "tasks" %>
<div id="tasks" class="min-w-full">
  <%= render @tasks %>
</div>
```

And correcting the order of tasks in the controller

```ruby
# app/controllers/tasks_controller.rb

def index
  @tasks = Task.order(created_at: :desc)
end
```

Making the details of a task updated in real time also

`app/views/tasks/show.html.erb`

```erb
<div class="flex w-full mx-auto md:w-2/3">
  <div class="mx-auto">
    <% if notice.present? %>
      <p class="inline-block px-3 py-2 mb-5 font-medium text-green-500 rounded-lg bg-green-50" id="notice"><%= notice %></p>
      <br />
    <% end %>
    <%= link_to "Back to tasks", tasks_path, class: "rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>

    <%=turbo_stream_from "tasks" %>
    <%= render @task %>
  </div>
</div>
```

`app/views/tasks/_task.html.erb`

```erb
<%=turbo_frame_tag "task_#{task.id}" do %>
  <!--...-->

  <%= link_to "Edit this task", edit_task_path(task), class: "rounded-lg py-3 ml-2 px-5 bg-gray-100 inline-block font-medium", target: "_top" %>
  <div class="inline-block ml-2">
    <%= button_to "Destroy this task", task_path(task), method: :delete, class: "mt-2 rounded-lg py-3 px-5 bg-gray-100 font-medium", target: "_top" %>
  </div>
  <hr class="mt-6">

  <!--...-->
<% end %>
```

## Module 4: Performing background updates

1. Updates by the console
- The console also reflects updates

```bash
bundle update redis
bundle install
```

`live_actions/config/cable.yml`

```yaml
development:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
  channel_prefix: live_actions_development
```

```bash
rails c
task = Task.last
task.update(title: 'Atualizando pelo console')
task = Task.create(title: 'Criando pelo console')
task.destroy
```

2. Creating Jobs to execute in the background
- Create the task job
- Perform the console

```bash
rails g job task
```

Atualizando o job de tarefas

```ruby
# app/jobs/task_job.rb

class TaskJob < ApplicationJob
  queue_as :default

  def perform(task)
    task.update(title: Faker::Lorem.sentence(word_count: 4), description: Faker::Lorem.paragraph)
  end
end
```

Updating in the background by the console

```bash
rails c
TaskJob.perform_now(Task.last)
TaskJob.perform_later(Task.last)
```

## Module 5: Search with Stimulus_reflex

1.The Stimulus_Reflex library serves to have the border and somehow a Backend class can communicate by events at the active session and perform operations without having to update the screen
- Installing and configuring the gem `Stimulus_reflex`
- Performing real -time operations
- Changing the home screen with a search box and button to filter
- Creating the Reflex class

```bash
bundle add stimulus_reflex
bundle install
rails stimulus_reflex:install
rails g stimulus_reflex task
```

Ajustando a tela inicial

`app/views/tasks/index.html.erb`

```erb

<div class="w-full">
  <% if notice.present? %>
    <p class="inline-block px-3 py-2 mb-5 font-medium text-green-500 rounded-lg bg-green-50" id="notice"><%= notice %></p>
  <% end %>

  <div class="flex items-center justify-between">
    <h1 class="text-4xl font-bold">Tasks</h1>
    <%= link_to "New task", new_task_path, class: "rounded-lg py-3 px-5 bg-blue-600 text-white block font-medium" %>
  </div>
  <hr />
    <%= form_with url: nil, data: { reflex: "submit->TaskReflex#search" } do |form| %>
    <div>
      <%= form.text_field :search, data: { reflex: "keyup->TaskReflex#search", reflex_dataset: "combined" }, class: 'shadow rounded-md border border-gray-200 outline-none px-3 py-2 mt-2', placeholder: 'Type and search...' %>
      <%= form.submit 'Search', class: 'rounded-lg py-3 px-5 bg-blue-600 text-white inline-block font-medium cursor-pointer' %>
    </div>
  <% end %>

  <%=turbo_stream_from "tasks" %>
  <div id="tasks" class="min-w-full">
    <%= render @tasks %>
  </div>
</div>
```

It's time to morphar!Search with events

```ruby
# app/reflexes/task_reflex.rb

class TaskReflex < ApplicationReflex
  def search
    @tasks = Task.order(created_at: :desc)
    if params[:search].present?
      @tasks = @tasks.where('title LIKE :search OR description LIKE :search', search: "%#{params[:search]}%")
    end

    morph '#tasks', render(@tasks)
  end
end
```

## Module 6: Conclusion

- Improvements and course review.
- Sidekiq <https://sidekiq.org/>
- Why is changes in views?
