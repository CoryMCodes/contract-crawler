# Architecture

## Overview

The application is split into three layers:

1. `Rails API`
2. `Ingestion + background execution`
3. `React frontend`

The Rails app is the system of record. Every crawl stores a raw source snapshot first, then parses and normalizes into shared opportunity records.

## Request Flow

### Search and detail

1. React calls `GET /opportunities` or `GET /opportunities/:id`.
2. Rails controllers delegate filtering to `Search::OpportunitySearch`.
3. Serializers shape API responses for list and detail views.

### Source sync

1. `POST /sources/:id/sync` enqueues `SourceSyncJob`.
2. `SourceSyncJob` delegates to `SourceIngestion::SyncSource`.
3. The ingestion service resolves a crawler via `Crawlers::Registry`.
4. Raw payloads are persisted as `SourceRecord` rows with fingerprints.
5. Parsed attributes flow through `Normalization::OpportunityNormalizer`.
6. Buyers and opportunities are upserted into normalized tables.

## Key Design Choices

### Raw-first ingestion

Every fetch persists the original payload before normalization. That gives us:

- replayability when parsers change
- auditability for source changes
- deterministic reprocessing

### Service boundaries

- `Search::*` owns filtering and ranking.
- `Normalization::*` owns schema mapping.
- `SourceIngestion::*` owns persistence and orchestration.
- `Crawlers::*` owns source-specific fetch and parse logic.
- `Ai::*` owns narrow enrichment behavior.

### Background execution

Sidekiq is the queue engine for:

- scheduled crawls
- retries
- enrichment work
- future dedupe and change detection

## Near-Term Expansion

- Add persistent `watchlists` and `saved_searches` tables and endpoints.
- Expand enrichment jobs to call a configurable LLM provider.
- Add `opportunity_updates`, `contacts`, and `vendors`.
- Add document storage and extraction for attachments.
- Add semantic retrieval with `pgvector` when document search justifies it.
