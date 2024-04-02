# Curso: Desenvolvimento de Aplicação Ruby on Rails com Eventos em tempo-real

## Introdução

Apresentação do curso e dos objetivos.

## Módulo 1: Configuração do Ambiente de Desenvolvimento com Ruby on Rails 7.x

1. Instalação do Ruby on Rails 7.x
   - Configuração inicial do projeto Rails.
   - Aplicando o framework com TailwindCSS
   - Instalando a gem `foreman` que ajuda a gerenciar processos de fundo

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

## Módulo 2: Desenvolvimento da Aplicação

1. Implementação do Controle de Tarefas
   - Criando tela de Tarefas
   - Utilização da gem `faker` e seeds
   - Acessando a aplicação.

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

Criando e populando com dados para desenvolvimento

```bash
rails db:drop db:create db:migrate db:seed
```

Corrigir a rota inicial

```ruby
# config/routes.rb
root "tasks#index"
```

E iniciando a aplicação para acessar <http://localhost:3000>

```bash
bin/dev
```

Melhorando `scheduled_at`

`app/views/tasks/_task.html.erb`

```erb
<%= I18n.l(task.scheduled_at, format: :long) if task.scheduled_at.present?  %>
```

## Módulo 3: Atualização de registros em tempo real com Hotwire

1. Hotwire e o conceito de atualização de registros
   - O conceito de broadcasting (refere-se à capacidade de enviar informações em tempo real para vários clientes conectados simultaneament)
   - O conceito de turbo-frames (permite atualizar partes específicas de uma página da web sem recarregar toda a página)
   - Em resumo, enquanto o broadcasting é usado para enviar informações em tempo real para vários clientes, os Turbo Frames são usados para atualizar partes específicas de uma página da web sem recarregar a página inteira, proporcionando uma experiência de usuário mais rápida e responsiva
   - Atualizando a lista ao criar, editar ou remover registros de Tarefas
   - Redis (é um banco de dados em memória de código aberto que é usado como estrutura de dados, cache e mecanismo de mensagens)


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

Tornando a lista possível para receber atualizações

`app/views/tasks/index.html.erb`

```erb
<%=turbo_stream_from "tasks" %>
<div id="tasks" class="min-w-full">
  <%= render @tasks %>
</div>
```

E corrigindo a ordem das Tarefas no controller

```ruby
# app/controllers/tasks_controller.rb

def index
  @tasks = Task.order(created_at: :desc)
end
```

Tornando os detalhes de uma Tarefa atualizados em tempo real também

`app/views/tasks/show.html.erb`

```erb
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

## Módulo 4: Executando atualizações em segundo plano

1. Atualizações pelo console
    - Pelo console também se refletem atualizações

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

2. Criando jobs para executar em segundo plano
    - Criar o job de tarefas
    - Performar pelo console

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

Atualizando em segundo plano pelo console

```bash
rails c
TaskJob.perform_now(Task.last)
TaskJob.perform_later(Task.last)
```

## Módulo 5: Buscas com stimulus_reflex

1 . A biblioteca stimulus_reflex serve para que o frontend e de certa forma uma classe do backend possam se comunicar por eventos na sessão ativa e realizar operações também sem precisar atualizar a tela
  - Instalando e configurando a gem `stimulus_reflex`
  - Executando operações em tempo real
  - Alterando a tela inicial com uma caixa de buscas e botão para filtrar
  - Criando a classe reflex

```bash
bundle add stimulus_reflex --version 3.5.0.rc3
bundle install
rails stimulus_reflex:install
rails g stimulus_reflex task
```

Ajustando a tela inicial

`app/views/tasks/index.html.erb`

```erb

<div class="w-full">
  <% if notice.present? %>
    <p class="py-2 px-3 bg-green-50 mb-5 text-green-500 font-medium rounded-lg inline-block" id="notice"><%= notice %></p>
  <% end %>

  <div class="flex justify-between items-center">
    <h1 class="font-bold text-4xl">Tasks</h1>
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

É hora de morphar! Buscas com eventos

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

## Módulo 6: Conclusão

- Melhorias e revisão do curso.
- Sidekiq <https://sidekiq.org/>
- Por que de mudanças em views?
