import type { SearchFiltersState } from "../types/opportunity";

interface SearchFiltersProps {
  filters: SearchFiltersState;
  onChange: (next: SearchFiltersState) => void;
  onSave: () => void;
}

export function SearchFilters({ filters, onChange, onSave }: SearchFiltersProps) {
  function update<K extends keyof SearchFiltersState>(key: K, value: SearchFiltersState[K]) {
    onChange({
      ...filters,
      [key]: value
    });
  }

  return (
    <section className="panel filters">
      <div className="panel__header">
        <div>
          <p className="eyebrow">Search</p>
          <h2>Find active opportunities quickly</h2>
        </div>
        <button className="button button--ghost" onClick={onSave} type="button">
          Save Search
        </button>
      </div>

      <div className="filters__grid">
        <label>
          Keyword
          <input value={filters.q} onChange={(event) => update("q", event.target.value)} placeholder="bridge repair" />
        </label>

        <label>
          Source
          <input value={filters.source} onChange={(event) => update("source", event.target.value)} placeholder="sam-gov" />
        </label>

        <label>
          State
          <input value={filters.state} onChange={(event) => update("state", event.target.value)} placeholder="TX" />
        </label>

        <label>
          Status
          <select value={filters.status} onChange={(event) => update("status", event.target.value)}>
            <option value="">Any</option>
            <option value="open">Open</option>
            <option value="closed">Closed</option>
            <option value="cancelled">Cancelled</option>
          </select>
        </label>

        <label>
          Due Before
          <input type="date" value={filters.due_before} onChange={(event) => update("due_before", event.target.value)} />
        </label>
      </div>
    </section>
  );
}
