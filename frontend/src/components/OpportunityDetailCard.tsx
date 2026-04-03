import type { OpportunityDetail } from "../types/opportunity";

interface OpportunityDetailCardProps {
  opportunity: OpportunityDetail;
}

export function OpportunityDetailCard({ opportunity }: OpportunityDetailCardProps) {
  return (
    <section className="panel detail-card">
      <div className="detail-card__header">
        <div>
          <p className="eyebrow">{opportunity.source_name}</p>
          <h2>{opportunity.title}</h2>
        </div>
        <div className="pill-row">
          <span className="pill">{opportunity.status}</span>
          <span className="pill">{opportunity.contract_type}</span>
          <span className="pill">{opportunity.set_aside}</span>
        </div>
      </div>

      <p>{opportunity.description}</p>

      <div className="detail-grid">
        <div>
          <span className="detail-label">Buyer</span>
          <strong>{opportunity.buyer_name}</strong>
        </div>
        <div>
          <span className="detail-label">Location</span>
          <strong>
            {[opportunity.city, opportunity.state].filter(Boolean).join(", ") || "Nationwide"}
          </strong>
        </div>
        <div>
          <span className="detail-label">Due Date</span>
          <strong>{opportunity.due_date ?? "TBD"}</strong>
        </div>
        <div>
          <span className="detail-label">Solicitation #</span>
          <strong>{opportunity.solicitation_number ?? "N/A"}</strong>
        </div>
      </div>
    </section>
  );
}
