module Crawlers
  module SamGov
    class Client
      def initialize(source:)
        @source = source
      end

      def fetch
        []
      end

      private

      attr_reader :source
    end
  end
end
