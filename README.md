# Course: Ruby on Rails Application Development with Time Events

## Introduction

Presentation of the course and objectives.

## Setup

All environments run with Docker. Copy the environment template and adjust values if needed:

```bash
cp .env.example .env
# macOS: set your user id so file permissions match
echo "UID=$(id -u)" >> .env
echo "GID=$(id -g)" >> .env
```

Build and start the application:

```bash
docker compose up --build
```

Access the app at http://localhost:3000

Code changes on the host are reflected immediately in the container via the bind mount (`.:/rails`).

## Offline Functionality

### Saving Data Offline

- When the user is offline, the application intercepts the form submission.
- The form data (e.g., message content) is stored in the browser's localStorage.

### Synchronizing Data with PostgreSQL

- Once the user comes back online, the application attempts to sync the offline data with the server.
- The saved data is sent to the server using the POST request and stored in the PostgreSQL database.

### CSRF Token Handling

- The application automatically includes the CSRF token with requests to ensure the data is submitted securely.
- If offline, the CSRF token is saved locally and included when syncing with the server.

## Docker

### First run

```bash
cp .env.example .env
docker compose up --build
```

The entrypoint runs `bundle install` (if needed) and `db:prepare` before starting the server.

### Database host

Inside Docker, `DB_HOST` is always `db` (set by `docker-compose.yml`). Your local `.env` can use `DB_HOST=localhost` for host-side tools — do **not** use `db_postgresql`; that was the old service name and will break connectivity.

### Bundle install (container + local sync)

Gems are installed to `vendor/bundle` on the host, shared with the container:

```bash
bin/docker-bundle
# or
docker compose run --rm web bundle install
```

This updates `Gemfile.lock` and `vendor/bundle` on your machine and inside the container.

### Common commands

```bash
docker compose run --rm web bin/rails db:reset
docker compose run --rm web bin/rails c
docker compose run --rm web bin/rails g model Post title:string
docker compose run --rm web bash
docker compose down
docker compose down -v   # also removes volumes
```

New models and migrations use **UUID** primary keys by default.

### Guard (tests with file watching)

With the app running, open another terminal:

```bash
docker compose exec -it guard bin/guard
```

Press **Enter** to run the full suite again. RSpec runs in the test environment automatically; no need to pass `RAILS_ENV=test`.

### One-off test run

```bash
docker compose run --rm web bundle exec rspec
```

### Reset Docker completely

```bash
docker compose down -v
docker system prune -a --volumes -f
```

## Production

Build and run the production image with the default Dockerfile:

```bash
docker build -t live_actions_rails .
docker run --rm -p 3000:3000 live_actions_rails
```

The production entrypoint runs `db:prepare` before starting the Rails server.
