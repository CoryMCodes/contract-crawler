export interface OpportunitySummary {
  id: number;
  external_id?: string;
  title: string;
  buyer_name?: string | null;
  source_name?: string | null;
  state?: string | null;
  city?: string | null;
  due_date?: string | null;
  posted_at?: string | null;
  status?: string | null;
  summary_ai?: string | null;
}

export interface OpportunityDetail extends OpportunitySummary {
  description?: string | null;
  source_url?: string | null;
  solicitation_number?: string | null;
  category?: string | null;
  contract_type?: string | null;
  set_aside?: string | null;
  estimated_value_low?: string | number | null;
  estimated_value_high?: string | number | null;
  naics_codes?: string[];
  raw_text?: string | null;
}

export interface Attachment {
  id: number;
  title: string;
  file_url: string;
  content_type?: string | null;
}

export interface Award {
  id: number;
  vendor_name: string;
  amount?: string | number | null;
  awarded_at?: string | null;
  award_number?: string | null;
  source_url?: string | null;
}

export interface OpportunityDetailResponse {
  data: OpportunityDetail;
  included: {
    awards: Award[];
    attachments: Attachment[];
  };
}

export interface SearchFiltersState {
  q: string;
  source: string;
  state: string;
  status: string;
  due_before: string;
}

export interface SavedSearch {
  id: string;
  name: string;
  filters: SearchFiltersState;
}
