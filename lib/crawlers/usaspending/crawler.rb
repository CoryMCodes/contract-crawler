module Crawlers
  module Usaspending
    class Crawler < BaseCrawler
      def initialize(source:)
        super(source:, client: Client.new(source:), parser: Parser.new(source:))
      end
    end
  end
end
