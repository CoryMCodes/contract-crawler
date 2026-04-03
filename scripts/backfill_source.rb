#!/usr/bin/env ruby

require_relative "../config/environment"

slug = ARGV.fetch(0) do
  abort "usage: ruby scripts/backfill_source.rb SOURCE_SLUG"
end

source = Source.find_by!(slug:)
SourceSyncJob.perform_async(source.id)

puts "Queued source sync for #{source.slug}"
