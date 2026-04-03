import { Link } from "react-router-dom";
import type { OpportunitySummary } from "../types/opportunity";

interface OpportunityCardProps {
  opportunity: OpportunitySummary;
  saved: boolean;
  onToggleSave: (opportunity: OpportunitySummary) => void;
}

export function OpportunityCard({ opportunity, saved, onToggleSave }: OpportunityCardProps) {
  return (
    <article className="card">
      <div className="card__meta">
        <span>{opportunity.source_name ?? "Unknown source"}</span>
        <span>{opportunity.state ?? "National"}</span>
        <span>{opportunity.status ?? "open"}</span>
      </div>

      <h3>{opportunity.title}</h3>
      <p className="card__buyer">{opportunity.buyer_name}</p>
      <p className="card__summary">{opportunity.summary_ai ?? "AI summary will appear after enrichment runs."}</p>

      <div className="card__footer">
        <Link className="button" to={`/opportunities/${opportunity.id}`}>
          Open Detail
        </Link>
        <button className="button button--ghost" onClick={() => onToggleSave(opportunity)} type="button">
          {saved ? "Remove" : "Save"}
        </button>
      </div>
    </article>
  );
}
