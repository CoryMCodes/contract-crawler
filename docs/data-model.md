# Data Model

## Implemented Tables

### `sources`

Tracks an onboarded upstream source.

- `name`
- `slug`
- `kind`
- `base_url`
- `active`
- `settings`
- `last_synced_at`

### `source_records`

Stores raw source snapshots.

- `source_id`
- `external_id`
- `fingerprint`
- `raw_payload`
- `raw_body`
- `fetched_at`
- `parser_version`
- `status`

### `buyers`

Normalized buyer metadata.

- `name`
- `state`
- `city`
- `source_identifier`
- `website_url`

### `opportunities`

Canonical opportunity records exposed by the API.

- `source_id`
- `source_record_id`
- `buyer_id`
- `external_id`
- `title`
- `description`
- `buyer_name`
- `state`
- `city`
- `source_name`
- `source_url`
- `solicitation_number`
- `category`
- `due_date`
- `posted_at`
- `contract_type`
- `set_aside`
- `estimated_value_low`
- `estimated_value_high`
- `naics_codes`
- `status`
- `raw_text`
- `summary_ai`
- `metadata`

### `attachments`

Metadata for bid files and source documents.

- `opportunity_id`
- `title`
- `file_url`
- `content_type`
- `metadata`

### `awards`

Past or related award data tied to an opportunity.

- `opportunity_id`
- `vendor_name`
- `amount`
- `awarded_at`
- `award_number`
- `source_url`

## Planned Next Tables

- `saved_searches`
- `watchlists`
- `watchlist_items`
- `contacts`
- `vendors`
- `opportunity_updates`

## Identity Rules

- `sources.slug` is unique.
- `source_records` are unique by `source_id + fingerprint`.
- `opportunities` are unique by `source_id + external_id`.

## Search Strategy

Search operates on:

- `title`
- `description`
- `raw_text`
- structured filters for source, state, status, and due date
