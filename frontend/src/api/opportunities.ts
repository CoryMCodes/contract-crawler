import { apiRequest } from "./client";
import type { OpportunityDetailResponse, OpportunitySummary, SearchFiltersState } from "../types/opportunity";

interface ListResponse {
  data: OpportunitySummary[];
}

export function fetchOpportunities(filters: Partial<SearchFiltersState>) {
  const search = new URLSearchParams();

  Object.entries(filters).forEach(([key, value]) => {
    if (value) {
      search.set(key, value);
    }
  });

  const suffix = search.toString() ? `?${search.toString()}` : "";
  return apiRequest<ListResponse>(`/opportunities${suffix}`);
}

export function fetchOpportunity(id: string) {
  return apiRequest<OpportunityDetailResponse>(`/opportunities/${id}`);
}
