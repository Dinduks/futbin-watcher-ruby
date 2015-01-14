#!/usr/bin/env ruby
#encoding: UTF-8

require 'nokogiri'
require 'open-uri'
require 'colored'
require 'table_print'

class Player
  attr_reader :name
  attr_reader :url
  attr_reader :target_price
  attr_reader :lowest_bin
  attr_reader :lowest_bin2
  attr_reader :lowest_bin3

  def initialize(name, url, target_price, lowest_bin, lowest_bin2, lowest_bin3)
    @name = name
    @url = url
    @target_price = target_price
    @lowest_bin = lowest_bin
    @lowest_bin2 = lowest_bin2
    @lowest_bin3 = lowest_bin3
  end

  def price_difference
    if @lowest_bin.nil? then '' else @target_price - @lowest_bin end
  end
end

def get_prices(platform, players)
  website = if platform == 'pc' then 'futpc.com' else 'futbin.com' end

  players.map do |url, target_price|
    html = open('http://' + website + url).read
    doc = Nokogiri::HTML(html)

    case platform
      when 'pc'
        player_name_element    = doc.xpath("//td")[4]
        lowest_bin_element     = doc.xpath('//div[contains(@class, "lowestBin")]//span').first
        snd_lowest_bin_element = doc.xpath("//td")[0]
        trd_lowest_bin_element = doc.xpath("//td")[2]
      when 'xbox'
        player_name_element    = doc.xpath("//td")[8]
        lowest_bin_element     = doc.xpath('//div[contains(@id, "xboxlowest")]').first
        snd_lowest_bin_element = doc.xpath('//div[contains(@id, "xboxlowest2")]').first
        trd_lowest_bin_element = doc.xpath('//div[contains(@id, "xboxlowest3")]').first
      when 'ps'
        player_name_element    = doc.xpath("//td")[8]
        lowest_bin_element     = doc.xpath('//div[contains(@id, "pslowest")]').first
        snd_lowest_bin_element = doc.xpath('//div[contains(@id, "pslowest2")]').first
        trd_lowest_bin_element = doc.xpath('//div[contains(@id, "pslowest3")]').first
      else
        raise "Platform '#{platform}' unrecognized."
    end

    player_name    = player_name_element.text
    lowest_bin     = lowest_bin_element.text.gsub(',', '').to_i
    snd_lowest_bin = snd_lowest_bin_element.text.gsub(',', '').to_i
    trd_lowest_bin = trd_lowest_bin_element.text.gsub(',', '').to_i

    Player.new(player_name, url, target_price, lowest_bin, snd_lowest_bin, trd_lowest_bin)
  end
end
