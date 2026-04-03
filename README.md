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

### Add Your SAM.gov API Key

Create a local env file from the committed template:

```bash
cp .env.example .env
```

Then edit `.env` and set:

```bash
SAM_GOV_API_KEY=your_real_sam_gov_public_api_key
```

After updating the key, restart the Rails containers so the new env var is loaded:

```bash
docker compose up -d --build api worker
```

The key stays out of git because `.env` is ignored, while [`.env.example`](/Users/corymusick/code/contract-crawler/.env.example) documents the expected variables.

### Run Tests

```bash
docker compose run --rm api bash -lc "bundle install && RAILS_ENV=test bin/rails db:prepare && RAILS_ENV=test bundle exec rspec"
```

### Seed Sources

```bash
docker compose run --rm api bash -lc "bundle install && bin/rails db:seed"
```

### Run A SAM.gov Sync

Once your key is in `.env`, trigger the seeded SAM.gov source:

```bash
curl -X POST http://localhost:3000/sources/1/sync
```

Then check the imported opportunities:

```bash
curl http://localhost:3000/opportunities
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
