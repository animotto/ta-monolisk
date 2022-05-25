# frozen_string_literal: true

require 'json'

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

  data = GAME.api.top_players_by_glory
  data = JSON.parse(data)

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
    end
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

  data = GAME.api.top_players_by_stars
  data = JSON.parse(data)

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
    end
  )

  shell.puts(table)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end
