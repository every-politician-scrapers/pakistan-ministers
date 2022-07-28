#!/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'pry'
require 'scraped'
require 'wikidata_ids_decorator'

class RemoveReferences < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('sup.reference').remove
    end.to_s
  end
end

class MinistersList < Scraped::HTML
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  field :ministers do
    member_entries.map { |ul| fragment(ul => Officeholder).to_h }
  end

  private

  def member_entries
    table.flat_map { |table| table.xpath('.//tr[td]') }
  end

  def table
    noko.xpath('//table[.//th[contains(.,"tenure")]]')
  end
end

class Officeholder < Scraped::HTML
  field :region do
    region_link.attr('wikidata')
  end

  field :regionLabel do
    region_link.text.tidy
  end

  field :person do
    name_link.attr('wikidata')
  end

  field :personLabel do
    name_link.text.tidy
  end

  field :start do
    Date.parse(tds[2].text.tidy.split('(').first)
  end

  private

  def tds
    noko.css('td')
  end

  def name_link
    tds[1].xpath('.//a[@href]')
  end

  def region_link
    tds[0].xpath('.//a[@href]').first
  end
end

url = ARGV.first
data = MinistersList.new(response: Scraped::Request.new(url: url).response).ministers

header = data.first.keys.to_csv
rows = data.map { |row| row.values.to_csv }
abort 'No results' if rows.count.zero?

puts header + rows.join
