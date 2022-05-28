#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Portrait'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name img start end].freeze
    end

    def empty?
      super || tds[0].text.tidy.empty? || (startDate < '1970-01-01')
    end

    def raw_start
      start_cell.children.map(&:text).join(' ').gsub(/\(.*?\)/, '').tidy
    end

    def raw_end
      end_cell.children.map(&:text).join(' ').gsub(/\(.*?\)/, '').tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
