import type { OpportunityDetail } from "../types/opportunity";

interface AiSummaryPanelProps {
  opportunity: OpportunityDetail;
}

export function AiSummaryPanel({ opportunity }: AiSummaryPanelProps) {
  const extractedFields = [
    ["Contract Type", opportunity.contract_type ?? "Unknown"],
    ["Set Aside", opportunity.set_aside ?? "Unknown"],
    ["NAICS", opportunity.naics_codes?.join(", ") || "Unknown"],
    ["Due Date", opportunity.due_date ?? "Unknown"]
  ];

  return (
    <section className="panel ai-panel">
      <div className="panel__header">
        <div>
          <p className="eyebrow">AI Layer</p>
          <h2>Summary and extraction</h2>
        </div>
      </div>

      <p className="ai-panel__summary">
        {opportunity.summary_ai ?? "Run enrichment to populate a concise opportunity summary here."}
      </p>

      <div className="ai-panel__fields">
        {extractedFields.map(([label, value]) => (
          <div className="ai-field" key={label}>
            <span>{label}</span>
            <strong>{value}</strong>
          </div>
        ))}
      </div>
    </section>
  );
}
