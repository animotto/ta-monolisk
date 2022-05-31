# frozen_string_literal: true

##
# Top players monitoring

INTERVAL = 60

def start
  unless @game.connected?
    @logger.fail(NOT_CONNECTED)
    return
  end

  top = nil
  loop do
    data = @game.api.top_players_by_glory
    data = JSON.parse(data)
    unless top
      top = data
      next
    end

    players = []
    data['playerEntries'].each_with_index do |player, i|
      prev = top['playerEntries'].detect.with_index { |p, j| p['playerId'] == player['playerId'] && i < j }
      next unless prev

      players << "#{player['name']} takes #{i + 1} place (+#{player['glory'] - prev['glory']})"
    end

    top = data
    next if players.empty?

    @logger.warning(players.join(', '))
  rescue Monolisk::RequestError => e
    @logger.fail(e)
  ensure
    Kernel.sleep(INTERVAL)
  end
end
