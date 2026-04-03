import { Link } from "react-router-dom";
import { useSavedSearches } from "../hooks/useSavedSearches";
import { useWatchlist } from "../hooks/useWatchlist";

export function SavedSearchesPage() {
  const { items: searches, remove } = useSavedSearches();
  const { items: watchlist } = useWatchlist();

  return (
    <div className="page-grid">
      <section className="panel">
        <p className="eyebrow">Saved Searches</p>
        <h2>Reusable search presets and watchlist shortcuts</h2>
      </section>

      <div className="content-layout">
        <section className="panel">
          <div className="panel__header">
            <div>
              <p className="eyebrow">Saved filters</p>
              <h2>Search presets</h2>
            </div>
          </div>

          <div className="list-stack">
            {searches.length === 0 && <p className="muted">Save a search from the main search screen to keep it here.</p>}
            {searches.map((search) => (
              <div className="list-row" key={search.id}>
                <div>
                  <strong>{search.name}</strong>
                  <span>{Object.entries(search.filters).filter(([, value]) => value).map(([key, value]) => `${key}:${value}`).join(" · ")}</span>
                </div>
                <div className="row-actions">
                  <Link
                    className="button button--ghost"
                    to={{
                      pathname: "/",
                      search: `?${new URLSearchParams(
                        Object.entries(search.filters).filter(([, value]) => value)
                      ).toString()}`
                    }}
                  >
                    Open
                  </Link>
                  <button className="button button--ghost" onClick={() => remove(search.id)} type="button">
                    Remove
                  </button>
                </div>
              </div>
            ))}
          </div>
        </section>

        <section className="panel">
          <div className="panel__header">
            <div>
              <p className="eyebrow">Watchlist</p>
              <h2>Saved opportunities</h2>
            </div>
          </div>

          <div className="list-stack">
            {watchlist.length === 0 && <p className="muted">Saved opportunities from the search and detail views appear here.</p>}
            {watchlist.map((item) => (
              <Link className="list-row" key={item.id} to={`/opportunities/${item.id}`}>
                <strong>{item.title}</strong>
                <span>{item.source_name}</span>
              </Link>
            ))}
          </div>
        </section>
      </div>
    </div>
  );
}
