import { Link, useParams } from "react-router-dom";
import { AiSummaryPanel } from "../components/AiSummaryPanel";
import { OpportunityDetailCard } from "../components/OpportunityDetailCard";
import { useOpportunity } from "../hooks/useOpportunity";
import { useWatchlist } from "../hooks/useWatchlist";

export function OpportunityDetailPage() {
  const { id } = useParams();
  const { data, loading, error } = useOpportunity(id);
  const { ids, toggle } = useWatchlist();

  if (loading) {
    return <section className="panel">Loading opportunity...</section>;
  }

  if (error || !data) {
    return <section className="panel error-panel">{error ?? "Opportunity not found."}</section>;
  }

  const opportunity = data.data;
  const saved = ids.has(opportunity.id);

  return (
    <div className="page-grid">
      <Link className="back-link" to="/">
        Back to search
      </Link>

      <div className="content-layout content-layout--detail">
        <div className="detail-stack">
          <OpportunityDetailCard opportunity={opportunity} />

          <section className="panel">
            <div className="panel__header">
              <div>
                <p className="eyebrow">Related Past Awards</p>
                <h2>Comparable vendor history</h2>
              </div>
              <button className="button button--ghost" onClick={() => toggle(opportunity)} type="button">
                {saved ? "Remove from watchlist" : "Save opportunity"}
              </button>
            </div>

            <div className="list-stack">
              {data.included.awards.length === 0 && <p className="muted">No past awards attached yet.</p>}
              {data.included.awards.map((award) => (
                <div className="list-row" key={award.id}>
                  <strong>{award.vendor_name}</strong>
                  <span>{award.amount ?? "Amount pending"}</span>
                </div>
              ))}
            </div>
          </section>

          <section className="panel">
            <div className="panel__header">
              <div>
                <p className="eyebrow">Attachments</p>
                <h2>Bid package and source files</h2>
              </div>
            </div>

            <div className="list-stack">
              {data.included.attachments.length === 0 && <p className="muted">No attachments stored yet.</p>}
              {data.included.attachments.map((attachment) => (
                <a className="list-row" href={attachment.file_url} key={attachment.id} rel="noreferrer" target="_blank">
                  <strong>{attachment.title}</strong>
                  <span>{attachment.content_type ?? "file"}</span>
                </a>
              ))}
            </div>
          </section>
        </div>

        <AiSummaryPanel opportunity={opportunity} />
      </div>
    </div>
  );
}
