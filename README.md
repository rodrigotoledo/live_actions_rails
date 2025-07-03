# Curso: Desenvolvimento de Aplicação Ruby on Rails com Eventos em tempo-real

## Introdução

Apresentação do curso e dos objetivos.

## Setup

1 - Clone from server

```bash
git clone ...
```

2 - Bundle install

```bash
bundle install
```

3 - Create database and migrate

```bash
rails db:create db:migrate db:seed
```

4 - Access localhost from http://localhost:3000

## Offline Functionality

### Saving Data Offline

- When the user is offline, the application intercepts the form submission.
- The form data (e.g., message content) is stored in the browser’s localStorage.

### Synchronizing Data with PostgreSQL

- Once the user comes back online, the application attempts to sync the offline data with the server.
- The saved data is sent to the server using the POST request and stored in the PostgreSQL database.

### CSRF Token Handling

- The application automatically includes the CSRF token with requests to ensure the data is submitted securely.
- If offline, the CSRF token is saved locally and included when syncing with the server.

## With Docker

Need To Clean All Your Docker?

```bash
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi -f $(docker images -aq)
docker system prune -a --volumes -f
docker network rm $(docker network ls -q)
rm .db-created
rm .db-seeded
chmod 777 Gemfile.lock
```

## Putting In Development Mode

Whereas It Is Necessary To Run With Your User, Run

```bash
id -u
```

And Change The Dockerfile.Development File With The Value You Found

So Build You Just Need To Run The First Time:

```bash
docker compose -f docker-compose.development.yml build
```

And To Climb The Application Rode:

```bash
FORCE_DB_CREATE=true FORCE_DB_SEED=true docker compose -f docker-compose.development.yml down
FORCE_DB_CREATE=true FORCE_DB_SEED=true docker compose -f docker-compose.development.yml up --build
FORCE_DB_CREATE=true FORCE_DB_SEED=true docker compose -f docker-compose.development.yml up
docker compose -f docker-compose.development.yml down -v
docker compose -f docker-compose.development.yml run app bundle install
docker compose -f docker-compose.development.yml run app bash
docker compose -f docker-compose.development.yml run app rails active_storage:install
```

## Migrations

To Run Migrations, Tests ... Etc, Run The App With Whatever Is Needed:

```bash
docker compose -f docker-compose.development.yml run app rails db:drop db:create db:migrate
```

## Rails Commands

Example Of Interaction Between Computer and Container:

```bash
docker compose -f docker-compose.development.yml run app rails c
docker compose -f docker-compose.development.yml run app rails g scaffold post title
docker compose -f docker-compose.development.yml run app rails g scaffold comment post:references comment:text
```

## Testing with Docker

For Tests For Example Run `Guard`:

```bash
docker compose -f docker-compose.development.yml run -e RAILS_ENV=test app bundle exec guard
```

For Migrations (Remembering That You May Need To Run Both In Development And Test):

```bash
docker compose -f docker-compose.development.yml run app rails db:migrate
```

## Putting Down

If You Want To Stop The Services:

```bash
docker compose -f docker-compose.development.yml down -v
```
