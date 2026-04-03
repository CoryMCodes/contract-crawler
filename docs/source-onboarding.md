# Source Onboarding

## Goal

Each new source should fit the same ingestion pattern:

1. fetch raw payloads
2. snapshot them into `source_records`
3. parse source-specific fields
4. normalize into the shared schema
5. enrich and dedupe later

## Required Files

For a new source `example_source`, add:

```text
lib/crawlers/example_source/
  crawler.rb
  client.rb
  parser.rb
```

Then register it in [`lib/crawlers/registry.rb`](/Users/corymusick/code/contract-crawler/lib/crawlers/registry.rb).

## Implementation Checklist

### Client

- prefer official APIs over scraping
- respect robots, terms, and rate limits
- return raw payload objects only

### Parser

- map source-specific keys into a stable intermediate hash
- do not normalize enums here
- keep enough raw text for search and auditability

### Normalizer

- map parser output into the shared schema
- normalize enums like status and set-aside
- preserve source URLs and identifiers

## Operational Rules

- Persist raw payloads before normalization.
- Keep crawlers idempotent.
- Always produce a fingerprint per payload.
- Capture enough raw content to support parser replays.
- Avoid source-specific behavior leaking into the API layer.
- Keep API keys and secrets in environment variables or a secret manager, not in `source.settings` seeds or committed config files.
