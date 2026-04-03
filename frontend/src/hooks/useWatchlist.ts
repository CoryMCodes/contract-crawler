import { useEffect, useMemo, useState } from "react";
import type { OpportunitySummary } from "../types/opportunity";

const STORAGE_KEY = "gov-contract-crawler:watchlist";

export function useWatchlist() {
  const [items, setItems] = useState<OpportunitySummary[]>([]);

  useEffect(() => {
    const rawValue = window.localStorage.getItem(STORAGE_KEY);
    if (rawValue) {
      setItems(JSON.parse(rawValue) as OpportunitySummary[]);
    }
  }, []);

  useEffect(() => {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
  }, [items]);

  const ids = useMemo(() => new Set(items.map((item) => item.id)), [items]);

  function toggle(opportunity: OpportunitySummary) {
    setItems((current) => {
      if (current.some((item) => item.id === opportunity.id)) {
        return current.filter((item) => item.id !== opportunity.id);
      }

      return [opportunity, ...current];
    });
  }

  return { items, ids, toggle };
}
