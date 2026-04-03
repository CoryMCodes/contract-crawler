class AwardSerializer
  class << self
    def render_collection(awards)
      awards.map do |award|
        award.slice("id", "vendor_name", "amount", "awarded_at", "award_number", "source_url")
      end
    end
  end
end
