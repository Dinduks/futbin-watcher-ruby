require 'sinatra'
require_relative 'futbin_watcher'
require_relative 'players_list'

set :bind, '0.0.0.0'

def commas(number)
  chunks = []
  number.reverse!
  while number.length > 0
    chunks << number.slice!(0,3)
  end
  chunks.join(',').reverse.gsub(/,/, ' ').gsub(/- /, ' -')
end

def colorize_price(str)
  if str.include? '-' then '<span style="color:red">'+str+'</span>' else str.green end
end

class PriceFormatter
  def format(value)
    if value.to_s.empty? then '' else commas('% 9d' % value.to_s) end
  end
end

class PriceDifferenceFormatter
  def format(value)
    if value.to_s.empty? then '' else colorize_price(commas('% 9d' % value.to_s)) end
  end
end

def print_for_web(players)
  total = [0, 0, 0, 0]
  players.each do |player|
    total[0] += player.target_price
    total[1] += player.lowest_bin
    total[2] += player.lowest_bin2
    total[3] += player.lowest_bin3
  end

  players.push(Player.new('', '', nil, nil, nil, nil))
  players.push(Player.new('Total', '', total[0], total[1], total[2], total[3]))

  tp.set Player, :name, :target_price, :lowest_bin, :price_difference
  options = {
    #:name => {:display_name => 'Player'},
    #:target_price => {:formatters => [PriceFormatter.new], :width => 33},
    #:lowest_bin   => {:display_name => 'Lowest BIN', :formatters => [PriceFormatter.new]},
    #:price_difference => {:formatters => [PriceDifferenceFormatter.new]}
  }

  '<pre>' + TablePrint::Printer.new(players, options).table_print + '</pre>'
end

def ƒ(platform)
  players = get_prices(platform, PLAYERS_LIST)
  print_for_web(players)
end

get '/xbox' do ƒ('xbox') end
get '/ps'   do ƒ('ps') end
get '/pc'   do ƒ('pc') end
