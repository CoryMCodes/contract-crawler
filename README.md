# ContractCrawler

ContractCrawler is a full-stack application for ingesting, normalizing, and searching government contract opportunities.

It is designed to transform fragmented public procurement data into a structured, searchable dataset that supports exploration, filtering, and workflow-driven analysis.

## Problem
Government contract data is:

- Distributed across multiple sources (SAM.gov, USAspending, etc.)
- Inconsistent in structure and quality
- Difficult to search and aggregate effectively

This project focuses on building a pipeline that:

- Ingests raw source data
- Normalizes it into a consistent schema
- Exposes it through a clean API and UI
  
## Architecture Overview
- Backend: Rails 8 API
- Database: PostgreSQL
- Background Processing: Sidekiq + Redis
- Frontend: React + TypeScript
- Infrastructure: Docker / Docker Compose

## Core Concepts
# Raw Data Preservation

All source payloads are stored before normalization.

This allows:

- Reprocessing as normalization logic evolves
- Debugging inconsistencies across sources

# Normalization Layer

Each source is mapped into a shared Opportunity schema.

This enables:

- Consistent querying across sources
- Unified filtering and search

# Idempotent Ingestion

Records are fingerprinted per source to prevent duplication and support safe reprocessing.

# Search API

Supports filtering by:

- keyword
- source
- state
- status
- due date
- 
## Current Status (MVP)

The current implementation includes:

- Rails API with core models and endpoints
- Background job entry points for ingestion workflows
- Source ingestion service with pluggable adapters
- Search API with basic filtering
- React frontend scaffold for search and detail views
- 
# Supported Sources
- SAM.gov (partial implementation)
- USAspending (stubbed)
- 
## Quick Start

# Prerequisites

- Docker Desktop
- Docker Compose

# Boot The Stack

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

The key stays out of git because `.env` is ignored, while [`.env.example`](/.env.example) documents the expected variables.

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

The React app lives in [`frontend/`](frontend/) and is scaffolded to consume the Rails API contract. The initial watchlist and saved-search UX is local-storage backed while the backend persistence layer is still being expanded.

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

## Design Goals
- Structured data over raw ingestion
- Clear separation between ingestion and normalization
- Idempotent, repeatable processing workflows
- Simple API surface for querying opportunities

## Future Work
- Expand source adapters and ingestion coverage
- Improve search with ranking and indexing strategies
- Add persistence for user workflows (saved searches, watchlists)
- Introduce AI-assisted summarization and extraction

## Docs

- [Architecture](/docs/architecture.md)
- [Data Model](/docs/data-model.md)
- [Source Onboarding](/docs/source-onboarding.md)

## Notes

- Raw source payloads are stored before normalization.
- Source records are fingerprinted and idempotent per source.
- Search uses Postgres full-text primitives for the first release.
- The AI layer is intentionally narrow in v1.
