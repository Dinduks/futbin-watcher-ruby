#!/usr/bin/env ruby
#encoding: UTF-8

require 'nokogiri'
require 'open-uri'
require 'growl'

def commas(number)
  chunks = []
  number.reverse!
  while (number.length > 0)
    chunks << number.slice!(0,3)
  end
  chunks.join(',').reverse.gsub(/,/, ' ').gsub(/- /, ' -')
end

players = {
  "Ronaldo  " => [6000000, "http://www.futpc.com/player/3072/cristiano-ronaldo"],
  "Messi    " => [4000000, "http://www.futpc.com/player/3071/lionel-messi"],
  "Robben   " => [ 850000, "http://www.futpc.com/player/3074/arjen-robben"],
  #"Suarez   " => [      0, "http://www.futpc.com/player/3075/luis-su%C3%A1rez"],
  #"Neymar   " => [      0, "http://www.futpc.com/player/3091/neymar"],
  "Modric   " => [  30000, "http://www.futpc.com/player/3083/luka-modric"],
  "Iniesta  " => [  20000, "http://www.futpc.com/player/3076/iniesta"],
  "Lahm     " => [  25000, "http://www.futpc.com/player/3088/philipp-lahm"],
  "Alba     " => [  10000, "http://www.futpc.com/player/3209/jordi-alba"],
  "Ramos    " => [ 180000, "http://www.futpc.com/player/3086/sergio-ramos"],
  "Piszczek " => [  10000, "http://www.futpc.com/player/3171/lukasz-piszczek"],
  "Neuer    " => [ 350000, "http://www.futpc.com/player/21155/manuel-neuer"],
}

print "Player         Target price       BIN price      Difference\n"
print "-----------------------------------------------------------\n"

total = [0, 0, 0, 0]

players.map do |player, price_and_link|
  html = open(price_and_link[1]).read
  doc = Nokogiri::HTML(html)

  case ARGV[0].downcase
  when "pc"
    lowest_bin     = doc.xpath('//div[contains(@class, "lowestBin")]//span').first.text.gsub(',', '').to_i
    snd_lowest_bin = doc.xpath("//td")[0].text.gsub(',', '').to_i
    trd_lowest_bin = doc.xpath("//td")[2].text.gsub(',', '').to_i
  when "xbox"
    lowest_bin     = doc.xpath('//div[contains(@id, "xboxlowest")]').first.text.gsub(',', '').to_i
    snd_lowest_bin = doc.xpath('//div[contains(@id, "xboxlowest2")]').first.text.gsub(',', '').to_i
    trd_lowest_bin = doc.xpath('//div[contains(@id, "xboxlowest3")]').first.text.gsub(',', '').to_i
  when "ps"
    lowest_bin     = doc.xpath('//div[contains(@id, "pslowest")]').first.text.gsub(',', '').to_i
    snd_lowest_bin = doc.xpath('//div[contains(@id, "pslowest2")]').first.text.gsub(',', '').to_i
    trd_lowest_bin = doc.xpath('//div[contains(@id, "pslowest3")]').first.text.gsub(',', '').to_i
  else
    raise "Platform '#{ARGV[0]}' unrecognized."
  end

  total[0] += price_and_link[0]
  total[1] += lowest_bin
  total[2] += snd_lowest_bin
  total[3] += trd_lowest_bin

  print "#{player}\t"
  print commas("% 9d" % price_and_link[0]) + "\t"
  print commas("% 9d" % lowest_bin) + "\t"
  print commas("% 9d" % (price_and_link[0] - lowest_bin)) + "\t"
  #print commas("% 9d" % snd_lowest_bin) + "\t"
  #print commas("% 9d" % trd_lowest_bin)
  print "\n"
end

print "\nTotal   \t#{commas("% 9d" % total[0])}"
print "\t#{commas("% 9d" % total[1])}"
print "\t#{commas("% 9d" % (total[0] - total[2]))}"
#print "\t#{commas("% 9d" % total[2])}"
#print "\t#{commas("% 9d" % total[3])}"
print "\n"
