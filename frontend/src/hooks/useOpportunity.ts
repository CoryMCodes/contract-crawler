import { useEffect, useState } from "react";
import { fetchOpportunity } from "../api/opportunities";
import type { OpportunityDetailResponse } from "../types/opportunity";

export function useOpportunity(id: string | undefined) {
  const [data, setData] = useState<OpportunityDetailResponse | null>(null);
  const [loading, setLoading] = useState(Boolean(id));
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) {
      setLoading(false);
      return;
    }

    let cancelled = false;
    setLoading(true);
    setError(null);

    fetchOpportunity(id)
      .then((response) => {
        if (!cancelled) {
          setData(response);
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
  }, [id]);

  return { data, loading, error };
}
