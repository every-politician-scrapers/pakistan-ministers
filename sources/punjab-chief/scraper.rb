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
      %w[no name img party _ start end].freeze
    end

    def empty?
      tds[0].text.tidy.empty? || super
    end

    def raw_start
      start_cell.children.map(&:text).join(' ').gsub(/\(.*?\)/, '').gsub('Yet to take oath', '').tidy
    end

    def raw_end
      end_cell.children.map(&:text).join(' ').gsub(/\(.*?\)/, '').gsub('Todate', 'Incumbent').tidy
    end

    def ignore_before
      1999
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
