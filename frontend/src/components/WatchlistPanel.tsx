import { Link } from "react-router-dom";
import type { OpportunitySummary } from "../types/opportunity";

interface WatchlistPanelProps {
  items: OpportunitySummary[];
}

export function WatchlistPanel({ items }: WatchlistPanelProps) {
  return (
    <aside className="panel watchlist-panel">
      <div className="panel__header">
        <div>
          <p className="eyebrow">Watchlist</p>
          <h2>Saved opportunities</h2>
        </div>
        <Link className="button button--ghost" to="/saved">
          Open Saved
        </Link>
      </div>

      {items.length === 0 ? (
        <p className="muted">Save any result to keep it visible here while backend watchlists are being wired in.</p>
      ) : (
        <div className="watchlist-items">
          {items.slice(0, 5).map((item) => (
            <Link className="watchlist-item" key={item.id} to={`/opportunities/${item.id}`}>
              <strong>{item.title}</strong>
              <span>{item.source_name}</span>
            </Link>
          ))}
        </div>
      )}
    </aside>
  );
}
