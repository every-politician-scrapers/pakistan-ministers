#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'
require 'every_politician_scraper/scraper_data'
require 'pry'

class Comparison < EveryPoliticianScraper::DecoratedComparison
  def columns
    super + %i[psid]
  end
end

diff = Comparison.new('wikidata.csv', 'scraped.csv').diff
puts diff.sort_by { |r| [r.first.to_s, r[1].to_s] }.reverse.map(&:to_csv)
