require "digest"

module Crawlers
  class BaseCrawler
    def initialize(source:, client:, parser:)
      @source = source
      @client = client
      @parser = parser
    end

    def fetch
      client.fetch
    end

    def parse(raw_payload)
      parser.parse(raw_payload)
    end

    def external_id(raw_payload)
      parsed = parse(raw_payload)
      parsed.fetch(:external_id)
    end

    def fingerprint(raw_payload)
      payload = raw_payload.is_a?(String) ? raw_payload : Oj.dump(raw_payload, mode: :compat)
      "sha256:#{Digest::SHA256.hexdigest(payload)}"
    end

    private

    attr_reader :client, :parser, :source
  end
end
