#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      tds[1].text.tidy
    end

    def position
      tds[2].text.tidy
    end

    private

    def tds
      noko.css('td')
    end
  end

  class Members
    def member_container
      noko.css('table.table_bill').xpath('.//tr[.//td]')
    end
  end
end

file = Pathname.new 'mirror.html'
puts EveryPoliticianScraper::FileData.new(file).csv
