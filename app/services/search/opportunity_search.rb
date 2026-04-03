module Search
  class OpportunitySearch
    def initialize(relation: Opportunity.all, params: {})
      @relation = relation
      @params = params.to_h.symbolize_keys
    end

    def call
      scoped = relation
      scoped = apply_query(scoped)
      scoped = apply_source_filter(scoped)
      scoped = apply_state_filter(scoped)
      scoped = apply_status_filter(scoped)
      scoped = apply_due_before_filter(scoped)
      scoped = apply_due_after_filter(scoped)

      scoped.distinct.order(due_date: :asc, posted_at: :desc)
    end

    private

    attr_reader :params, :relation

    def apply_query(scoped)
      return scoped if params[:q].blank?

      scoped.where(
        <<~SQL.squish,
          to_tsvector(
            'english',
            coalesce(opportunities.title, '') || ' ' ||
            coalesce(opportunities.description, '') || ' ' ||
            coalesce(opportunities.raw_text, '')
          ) @@ websearch_to_tsquery('english', ?)
        SQL
        params[:q]
      )
    end

    def apply_source_filter(scoped)
      return scoped if params[:source].blank?

      scoped.joins(:source).where(sources: { slug: params[:source] })
    end

    def apply_state_filter(scoped)
      return scoped if params[:state].blank?

      scoped.where(state: params[:state].to_s.upcase)
    end

    def apply_status_filter(scoped)
      return scoped if params[:status].blank?

      scoped.where(status: params[:status].to_s.downcase)
    end

    def apply_due_before_filter(scoped)
      date = parse_date(params[:due_before])
      return scoped unless date

      scoped.where("opportunities.due_date <= ?", date)
    end

    def apply_due_after_filter(scoped)
      date = parse_date(params[:due_after])
      return scoped unless date

      scoped.where("opportunities.due_date >= ?", date)
    end

    def parse_date(value)
      return if value.blank?

      Date.iso8601(value.to_s)
    rescue Date::Error
      nil
    end
  end
end
