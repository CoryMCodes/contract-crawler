module Crawlers
  class Registry
    class UnsupportedSourceError < StandardError; end

    def self.build(source)
      case source.kind
      when "sam_gov"
        SamGov::Crawler.new(source:)
      when "usaspending"
        Usaspending::Crawler.new(source:)
      else
        raise UnsupportedSourceError, "No crawler registered for #{source.kind}"
      end
    end
  end
end
