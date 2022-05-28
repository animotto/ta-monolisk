# frozen_string_literal: true

require 'time'

## Commands

# glory
CONTEXT_TOP.add_command(
  :glory,
  description: 'Top players by glory'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  player = GAME.api.full_player_info
  player = JSON.parse(player)

  data = GAME.api.top_players_by_glory
  data = JSON.parse(data)

  selected = []
  data['playerEntries'].each_with_index do |p, i|
    next unless p['playerId'] == player.dig('player', 'id')

    selected << i
  end

  table = Printer::Table.new(
    'Glory',
    ['#', 'ID', 'Name', 'Exp', 'Glory'],
    data['playerEntries'].map.with_index do |p, i|
      [
        i + 1,
        p['playerId'],
        p['name'],
        p['exp'],
        p['glory']
      ]
    end,
    selected
  )

  shell.puts(table)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# stars
CONTEXT_TOP.add_command(
  :stars,
  description: 'Top players by stars'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  player = GAME.api.full_player_info
  player = JSON.parse(player)

  data = GAME.api.top_players_by_stars
  data = JSON.parse(data)

  selected = []
  data['playerEntries'].each_with_index do |p, i|
    next unless p['playerId'] == player.dig('player', 'id')

    selected << i
  end

  table = Printer::Table.new(
    'Glory',
    ['#', 'ID', 'Name', 'Exp', 'Glory', 'Stars'],
    data['playerEntries'].map.with_index do |p, i|
      [
        i + 1,
        p['playerId'],
        p['name'],
        p['exp'],
        p['glory'],
        p['perSeasonStarsCount']
      ]
    end,
    selected
  )

  shell.puts(table)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# season
CONTEXT_TOP.add_command(
  :season,
  description: 'Season info'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.season_info
  data = JSON.parse(data)

  list = Printer::List.new(
    'Season info',
    ['Current', 'Next date'],
    [
      data['currentSeasonName'],
      Time.parse(data['newSeasonUTCStartDate']).strftime('%d.%m.%Y')
    ]
  )

  shell.puts(list)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end
