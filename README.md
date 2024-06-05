# Course: Developing a Ruby on Rails Application with Real-time Events

## Introduction

📜 Presentation of the course and its objectives.

## Module 1: Setting Up the Development Environment with Ruby on Rails 7.x

1. 🛠️ Installing Ruby on Rails 7.x
  - ⚙️ Initial configuration of the Rails project.
  - 🎨 Applying the framework with TailwindCSS.
  - 📦 Installing the `foreman` gem to help manage background processes because we use `bin/dev`

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

1. 🗂️ Implementing Task Control
  - 🖥️ Creating the Task screen
  - 📊 Using the `faker` gem and seeds
  - 🌐 Accessing the application

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

  - 🌐 Creating and populating with development data

```bash
rails db:drop db:create db:migrate db:seed
```

  - 🛠️ Correcting the initial route
  - 🌐 Starting the application to access [http://localhost:3000](http://localhost:3000)

```ruby
# config/routes.rb
root "tasks#index"
```

```bash
bin/dev
```

Ajustando partial `_task.html.erb`

```erb
<!-- app/views/tasks/_task.html.erb -->
<div id="<%= dom_id task %>">
  <p class="my-5">
    <strong class="block font-medium mb-1">Title:</strong>
    <%= task.title %>
  </p>

  <p class="my-5">
    <strong class="block font-medium mb-1">Description:</strong>
    <%= task.description %>
  </p>

  <!-- Localize -->
  <p class="my-5">
    <strong class="block font-medium mb-1">Scheduled at:</strong>
    <%= I18n.l(task.scheduled_at, format: :long) if task.scheduled_at.present?  %>
  </p>

  <!-- Translation -->
  <p class="my-5">
    <strong class="block font-medium mb-1">Completed:</strong>
    <%= t(task.completed) if task.completed? %>
  </p>

  <!-- BG Color -->
  <%= link_to "Edit this task", edit_task_path(task), class: "rounded-lg py-3 ml-2 px-5 bg-blue-400 inline-block font-medium", target: "_top" %>
  <div class="inline-block ml-2">
    <%= button_to "Destroy this task", task_path(task), method: :delete, class: "mt-2 rounded-lg py-3 px-5 bg-red-400 font-medium", form: { data: { turbo_confirm: 'Are you sure?' } } %>
  </div>
  <hr class="mt-6">
</div>
```

## Module 3: Real-time Record Updates with Hotwire

1. ⚡ Hotwire and the Concept of Record Updates
  - 📡 The concept of broadcasting (refers to the ability to send real-time information to multiple connected clients simultaneously)
  - 🔄 The concept of turbo-frames (allows updating specific parts of a web page without reloading the entire page)
  - 📝 In summary, while broadcasting is used to send real-time information to multiple clients, Turbo Frames are used to update specific parts of a web page without reloading the entire page, providing a faster and more responsive user experience
  - 📋 Updating the list when creating, editing, or removing Task records
  - 🗄️ Redis (an open-source, in-memory database used as a data structure store, cache, and message broker)


```bash
bundle add turbo-rails
bundle install
rails turbo:install
rails turbo:install:redis
```

  - 📡 Implementing broadcasting and validation in the `Task` model

```ruby
# app/models/task.rb
class Task < ApplicationRecord
  validates :title, presence: true

  after_create_commit do
    broadcast_prepend_to 'tasks', target: 'tasks', partial: 'tasks/task', locals: { task: self }
  end
  broadcasts_refreshes
end
```

  - 📋 Making the list capable of receiving updates when creating, editing, or removing Task records

```erb
<!-- app/views/tasks/index.html.erb -->
<%=turbo_stream_from "tasks" %>
<div id="tasks" class="min-w-full">
  <%= render @tasks %>
</div>
```

  - 🔄 Correcting the order of `Task` in the controller

```ruby
# app/controllers/tasks_controller.rb

def index
  @tasks = Task.order(created_at: :desc)
end
```

  - 🔄 Ensuring the details of `Task` are also updated in real-time

```erb
<!-- app/views/tasks/show.html.erb -->
<div class="mx-auto md:w-2/3 w-full flex">
  <div class="mx-auto">
    <% if notice.present? %>
      <p class="py-2 px-3 bg-green-50 mb-5 text-green-500 font-medium rounded-lg inline-block" id="notice"><%= notice %></p>
      <br />
    <% end %>
    <%= link_to "Back to tasks", tasks_path, class: "rounded-lg py-3 px-5 bg-gray-100 inline-block font-medium" %>

    <%=turbo_stream_from "tasks" %>
    <%= render @task %>
  </div>
</div>
```

```erb
<!-- app/views/tasks/_task.html.erb -->
<%=turbo_stream_from task %>
  <!-- Rest of file -->
```

## Module 4: Performing Background Updates

1. Updates via the console
  - Updates via the console also reflect changes

```bash
bundle update redis
bundle install
```

```yaml
# live_actions/config/cable.yml
development:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
  channel_prefix: live_actions_development
```

```bash
rails c
task = Task.last
task.update(title: 'With Console')
task = Task.create(title: 'Ohhh! Its awesome!')
task.destroy
```

2. Creating jobs to run in the background
  - Creating the task job
  - Performing via the console

```bash
rails g job task
```

```ruby
# app/jobs/task_job.rb

class TaskJob < ApplicationJob
  queue_as :default

  def perform(task)
    task.update(title: Faker::Lorem.sentence(word_count: 4), description: Faker::Lorem.paragraph)
  end
end
```

```bash
rails c
TaskJob.perform_now(Task.last)
TaskJob.perform_later(Task.last)
```

## Module 5: Modifying the Initial Screen with stimulus_reflex

1. 🛠️ The stimulus_reflex library allows the frontend and, to some extent, a backend class to communicate through events in the active session and perform operations without needing to refresh the screen.
  - 📦 Installing and configuring the `stimulus_reflex` gem
  - ⚡ Performing real-time operations
  - 🧩 Creating the reflex class


```bash
bundle add stimulus_reflex
bundle install
rails stimulus_reflex:install
rails g stimulus_reflex task
```

  - 🖥️ Modifying the initial screen with a search box and button to filter

```erb
<!-- app/views/tasks/index.html.erb -->
<div class="w-full">
  <% if notice.present? %>
    <p class="py-2 px-3 bg-green-50 mb-5 text-green-500 font-medium rounded-lg inline-block" id="notice"><%= notice %></p>
  <% end %>

  <div class="flex justify-between items-center">
    <h1 class="font-bold text-4xl">Tasks</h1>
    <%= link_to "New task", new_task_path, class: "rounded-lg py-3 px-5 bg-blue-600 text-white block font-medium" %>
  </div>
  <hr />
  <!-- Stimulus Reflex actions -->
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

  -🌀 It's time to morph! Searches with events

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

  - 📝 Improvements in course translation and review.
  - ❓ Why make changes to views?


```yaml
# config/locales/en.yml
en:
  hello: "Hello world"
  true: "yes"
  false: "no"
```
