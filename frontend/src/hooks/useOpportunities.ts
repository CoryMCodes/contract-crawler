import { useEffect, useState } from "react";
import { fetchOpportunities } from "../api/opportunities";
import type { OpportunitySummary, SearchFiltersState } from "../types/opportunity";

export function useOpportunities(filters: Partial<SearchFiltersState>) {
  const [data, setData] = useState<OpportunitySummary[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;

    setLoading(true);
    setError(null);

    fetchOpportunities(filters)
      .then((response) => {
        if (!cancelled) {
          setData(response.data);
        }
      })
      .catch((requestError: Error) => {
        if (!cancelled) {
          setError(requestError.message);
        }
      })
      .finally(() => {
        if (!cancelled) {
          setLoading(false);
        }
      });

    return () => {
      cancelled = true;
    };
  }, [filters.due_before, filters.q, filters.source, filters.state, filters.status]);

  return { data, loading, error };
}
