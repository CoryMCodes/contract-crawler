import type { OpportunitySummary } from "../types/opportunity";
import { OpportunityCard } from "./OpportunityCard";

interface OpportunityListProps {
  opportunities: OpportunitySummary[];
  savedIds: Set<number>;
  onToggleSave: (opportunity: OpportunitySummary) => void;
}

export function OpportunityList({ opportunities, savedIds, onToggleSave }: OpportunityListProps) {
  if (opportunities.length === 0) {
    return (
      <section className="panel empty-state">
        <p className="eyebrow">No matches yet</p>
        <h2>Adjust the filters or seed a few source records to see live results.</h2>
      </section>
    );
  }

  return (
    <section className="results-grid">
      {opportunities.map((opportunity) => (
        <OpportunityCard
          key={opportunity.id}
          opportunity={opportunity}
          saved={savedIds.has(opportunity.id)}
          onToggleSave={onToggleSave}
        />
      ))}
    </section>
  );
}
