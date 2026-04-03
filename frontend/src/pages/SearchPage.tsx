import { useMemo, useState } from "react";
import { useSearchParams } from "react-router-dom";
import { SearchFilters } from "../components/SearchFilters";
import { OpportunityList } from "../components/OpportunityList";
import { WatchlistPanel } from "../components/WatchlistPanel";
import { useOpportunities } from "../hooks/useOpportunities";
import { useSavedSearches } from "../hooks/useSavedSearches";
import { useWatchlist } from "../hooks/useWatchlist";
import type { SearchFiltersState } from "../types/opportunity";

function filtersFromParams(searchParams: URLSearchParams): SearchFiltersState {
  return {
    q: searchParams.get("q") ?? "",
    source: searchParams.get("source") ?? "",
    state: searchParams.get("state") ?? "",
    status: searchParams.get("status") ?? "",
    due_before: searchParams.get("due_before") ?? ""
  };
}

export function SearchPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const [filters, setFilters] = useState<SearchFiltersState>(() => filtersFromParams(searchParams));
  const { data, loading, error } = useOpportunities(filters);
  const { items, ids, toggle } = useWatchlist();
  const { items: savedSearches, save } = useSavedSearches();

  const stats = useMemo(
    () => [
      { label: "Matches", value: data.length.toString() },
      { label: "Saved searches", value: savedSearches.length.toString() },
      { label: "Watchlist", value: items.length.toString() }
    ],
    [data.length, items.length, savedSearches.length]
  );

  function handleFiltersChange(next: SearchFiltersState) {
    setFilters(next);
    setSearchParams(
      Object.entries(next).filter(([, value]) => value.length > 0)
    );
  }

  function handleSaveSearch() {
    const name = window.prompt("Name this search");
    if (name) {
      save(name, filters);
    }
  }

  return (
    <div className="page-grid">
      <section className="hero panel">
        <p className="eyebrow">MVP Search Console</p>
        <h2>Surface public-sector opportunities before they slip through the cracks.</h2>
        <div className="hero__stats">
          {stats.map((stat) => (
            <div className="hero__stat" key={stat.label}>
              <strong>{stat.value}</strong>
              <span>{stat.label}</span>
            </div>
          ))}
        </div>
      </section>

      <SearchFilters filters={filters} onChange={handleFiltersChange} onSave={handleSaveSearch} />

      <div className="content-layout">
        <div>
          {loading && <section className="panel">Loading opportunities...</section>}
          {error && <section className="panel error-panel">{error}</section>}
          {!loading && !error && (
            <OpportunityList opportunities={data} savedIds={ids} onToggleSave={toggle} />
          )}
        </div>

        <WatchlistPanel items={items} />
      </div>
    </div>
  );
}
