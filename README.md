# Gov Contract Crawler

Government contract opportunity intelligence platform built with Rails 8, Postgres, Redis, Sidekiq, and a React + TypeScript frontend.

## What It Does

- Crawls public procurement and award sources.
- Persists raw payload snapshots before any normalization.
- Normalizes source-specific records into a shared opportunity schema.
- Exposes a Rails JSON API for search, filters, and detail views.
- Adds a visible AI layer for contract summaries and structured extraction hooks.

## Current MVP Slice

- Rails 8 API with Postgres-ready models and request endpoints.
- Sidekiq job entrypoints for source sync and enrichment.
- Source ingestion service with crawler registry and idempotent raw snapshot storage.
- Search API for keyword, source, state, status, and due date filters.
- React frontend scaffold for search, detail, saved searches, and watchlist UX.
- Source adapters stubbed for `SAM.gov` and `USAspending`.

## Quick Start

### Prerequisites

- Docker Desktop
- Docker Compose

### Boot The Stack

```bash
docker compose up --build
```

That starts:

- Rails API on `http://localhost:3000`
- Postgres on `localhost:5432`
- Redis on `localhost:6379`
- Sidekiq worker in a separate container
- React frontend on `http://localhost:5173`

### Run Tests

```bash
docker compose run --rm api bash -lc "bundle install && RAILS_ENV=test bin/rails db:prepare && RAILS_ENV=test bundle exec rspec"
```

### Seed Sources

```bash
docker compose run --rm api bash -lc "bundle install && bin/rails db:seed"
```

## API Endpoints

- `GET /opportunities`
- `GET /opportunities/:id`
- `POST /sources/:id/sync`

### Search Parameters

- `q`
- `source`
- `state`
- `status`
- `due_before`
- `due_after`

## Frontend

The React app lives in [`frontend/`](/Users/corymusick/code/contract-crawler/frontend) and is scaffolded to consume the Rails API contract. The initial watchlist and saved-search UX is local-storage backed while the backend persistence layer is still being expanded.

## Project Structure

```text
.
├── app/
├── config/
├── db/
├── docs/
├── frontend/
├── lib/
├── scripts/
└── spec/
```

## Docs

- [Architecture](/Users/corymusick/code/contract-crawler/docs/architecture.md)
- [Data Model](/Users/corymusick/code/contract-crawler/docs/data-model.md)
- [Source Onboarding](/Users/corymusick/code/contract-crawler/docs/source-onboarding.md)

## Notes

- Raw source payloads are stored before normalization.
- Source records are fingerprinted and idempotent per source.
- Search uses Postgres full-text primitives for the first release.
- The AI layer is intentionally narrow in v1.
