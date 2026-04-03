#!/usr/bin/env ruby

require_relative "../config/environment"

slug = ARGV.fetch(0) do
  abort "usage: ruby scripts/reparse_source_records.rb SOURCE_SLUG"
end

source = Source.find_by!(slug:)

source.source_records.find_each do |source_record|
  NormalizeSourceJob.perform_async(source_record.id)
end

puts "Queued normalization replay for #{source.slug}"
