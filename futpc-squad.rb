#!/usr/bin/env ruby
#encoding: UTF-8

require 'nokogiri'
require 'open-uri'

def commas(number)
  chunks = []
  number.reverse!
  while (number.length > 0)
    chunks << number.slice!(0,3)
  end
  chunks.join(',').reverse.gsub(/,/, ' ')
end

def get_players_prices(players)
  players_prices = {}
  players.map do |player, link|
    html = open(link).read
    doc = Nokogiri::HTML(html)

    lowest_bin     = doc.xpath('//div[contains(@class, "lowestBin")]//span').first.text.gsub(',', '').to_i
    snd_lowest_bin = doc.xpath("//td")[0].text.gsub(',', '').to_i
    trd_lowest_bin = doc.xpath("//td")[2].text.gsub(',', '').to_i

    players_prices[player.strip] = [lowest_bin, snd_lowest_bin, trd_lowest_bin]
  end

  players_prices
end

def get_squads_prices(squads, players_prices)
  squads_prices = {}
  squads.each do |squad_name, players|
    #x = 0
    #players.each { |player_name| x += players_prices[player_name][0] }
    squads_prices[squad_name] = [
      Proc.new {x = 0; players.each { |player_name| x += players_prices[player_name][0] }; x}.call,
      Proc.new {x = 0; players.each { |player_name| x += players_prices[player_name][1] }; x}.call,
      Proc.new {x = 0; players.each { |player_name| x += players_prices[player_name][2] }; x}.call
    ]
  end
  squads_prices
end

def print_squads_prices(squads_prices, squads)
  squads_prices.each do |squad_name, price|
    print squad_name.strip + ": "
    print squads[squad_name].inject { |first, next_| first.capitalize + ", " + next_.capitalize }
    print "\t\t\n#{commas("% 9d" % squads_prices[squad_name][0])}"
    print "\n"
    #print "\t#{commas("% 9d" % squads_prices[squad_name][1])}"
    #print "\t#{commas("% 9d" % squads_prices[squad_name][2])}\n"
  end
end

def print_players_prices(players_prices)
  players_prices.each do |player_name, prices|
    print "#{player_name}\t"
    print commas("% 9d" % prices[0]) + "\t"
    print commas("% 9d" % prices[1]) + "\t"
    print commas("% 9d" % prices[2]) + "\n"
  end
end

players = {
  "ronaldo  " => "http://www.futpc.com/player/3072/cristiano-ronaldo",
  "messi    " => "http://www.futpc.com/player/3071/lionel-messi",
  "robben   " => "http://www.futpc.com/player/3074/arjen-robben",
  "suarez   " => "http://www.futpc.com/player/3075/luis-su%c3%a1rez",
  "neuer    " => "http://www.futpc.com/player/21155/manuel-neuer",
  "neymar   " => "http://www.futpc.com/player/3091/neymar",
  "ramos    " => "http://www.futpc.com/player/3086/sergio-ramos",
  "modric   " => "http://www.futpc.com/player/3083/luka-modric",
  "lahm     " => "http://www.futpc.com/player/3088/philipp-lahm",
  "iniesta  " => "http://www.futpc.com/player/3076/iniesta",
  "godin    " => "http://www.futpc.com/player/21449/diego-god%C3%ADn",
  "benatia  " => "http://www.futpc.com/player/3120/medhi-benatia",
  "piszczek " => "http://www.futpc.com/player/3171/lukasz-piszczek",
  "james    " => "http://www.futpc.com/player/3090/james-rodr%C3%ADguez",
  "kroos    " => "http://www.futpc.com/player/21303/toni-kroos",
  "carvajal " => "http://www.futpc.com/player/21337/carvajal",
  "otamendi " => "http://www.futpc.com/player/21451/nicol%C3%A1s-otamendi",
  "alba     " => "http://www.futpc.com/player/3209/jordi-alba",
}

squads = {
  "Squad 1  " => [
    "ronaldo",
    "messi",
    "robben",
    "iniesta",
    "lahm",
    "modric",
    "alba",
    "ramos",
    "benatia",
    "piszczek",
    "neuer"
  ],
  "Squad 2  " => [
    "neymar",
    "ronaldo",
    "robben",
    "modric",
    "james",
    "lahm",
    "alba",
    "ramos",
    "benatia",
    "piszczek",
    "neuer",
  ],
  "Squad 3  " => [
    "ronaldo",
    "messi",
    "iniesta",
    "kroos",
    "modric",
    "alba",
    "ramos",
    "godin",
    "otamendi",
    "carvajal",
    "neuer",
  ]
}

players_prices = get_players_prices(players)
#print_players_prices(players_prices)

squads_prices  = get_squads_prices(squads, players_prices)
print_squads_prices(squads_prices, squads)
