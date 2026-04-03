import { useEffect, useState } from "react";
import type { SavedSearch, SearchFiltersState } from "../types/opportunity";

const STORAGE_KEY = "gov-contract-crawler:saved-searches";

export function useSavedSearches() {
  const [items, setItems] = useState<SavedSearch[]>([]);

  useEffect(() => {
    const rawValue = window.localStorage.getItem(STORAGE_KEY);
    if (rawValue) {
      setItems(JSON.parse(rawValue) as SavedSearch[]);
    }
  }, []);

  useEffect(() => {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
  }, [items]);

  function save(name: string, filters: SearchFiltersState) {
    setItems((current) => [
      {
        id: crypto.randomUUID(),
        name,
        filters
      },
      ...current
    ]);
  }

  function remove(id: string) {
    setItems((current) => current.filter((item) => item.id !== id));
  }

  return { items, save, remove };
}
