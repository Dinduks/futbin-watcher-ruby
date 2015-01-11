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
  "Ronaldo  " => "http://www.futpc.com/player/3072/cristiano-ronaldo",
  "Messi    " => "http://www.futpc.com/player/3071/lionel-messi",
  "Robben   " => "http://www.futpc.com/player/3074/arjen-robben",
  #"Suarez   " => "http://www.futpc.com/player/3075/luis-su%C3%A1rez",
  #"Neymar   " => "http://www.futpc.com/player/3091/neymar",
  "Modric   " => "http://www.futpc.com/player/3083/luka-modric",
  "Iniesta  " => "http://www.futpc.com/player/3076/iniesta",
  "Lahm     " => "http://www.futpc.com/player/3088/philipp-lahm",
  "Alba     " => "http://www.futpc.com/player/3209/jordi-alba",
  "Ramos    " => "http://www.futpc.com/player/3086/sergio-ramos",
  "Piszczek " => "http://www.futpc.com/player/3171/lukasz-piszczek",
  "Neuer    " => "http://www.futpc.com/player/21155/manuel-neuer",
}

total = [0, 0, 0]

players.map do |player, link|
  html = open(link).read
  doc = Nokogiri::HTML(html)

  lowest_bin     = doc.xpath('//div[contains(@class, "lowestBin")]//span').first.text.gsub(',', '')
  snd_lowest_bin = doc.xpath("//td")[0].text.gsub(',', '')
  trd_lowest_bin = doc.xpath("//td")[2].text.gsub(',', '')

  total[0] += lowest_bin.to_i
  total[1] += snd_lowest_bin.to_i
  total[2] += trd_lowest_bin.to_i

  print "#{player}\t"
  print commas("% 9d" % lowest_bin) + "\t"
  print commas("% 9d" % snd_lowest_bin) + "\t"
  print commas("% 9d" % trd_lowest_bin) + "\n"
end
print "\nTotal   \t#{commas("% 9d" % total[0])}\t#{commas("% 9d" % total[1])}\t#{commas("% 9d" % total[2])}"
print "\nDiff    \t#{commas("% 9d" % (13080000 - total[0]))}\t#{commas("% 9d" % (13080000 - total[1]))}\t#{commas("% 9d" % (13080000 - total[2]))}\n"
