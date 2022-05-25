# frozen_string_literal: true

require 'json'

## Commands

# glory
CONTEXT_TOP.add_command(
  :glory,
  description: 'Top players by glory'
) do |_tokens, shell|
  unless GAME.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  data = GAME.api.top_players_by_glory
  data = JSON.parse(data)

  shell.puts(
    format(
      '%-2s %-17s %-17s %-10s %-10s',
      '',
      'ID',
      'Name',
      'Experience',
      'Glory'
    )
  )
  data['playerEntries'].each_with_index do |player, i|
    shell.puts(
      format(
        '%-2d %-17d %-17s %-10d %-10d',
        i + 1,
        player['playerId'],
        player['name'],
        player['exp'],
        player['glory']
      )
    )
  end
rescue Monolisk::RequestError => e
  shell.puts(e)
end

# stars
CONTEXT_TOP.add_command(
  :stars,
  description: 'Top players by stars'
) do |_tokens, shell|
  unless GAME.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  data = GAME.api.top_players_by_stars
  data = JSON.parse(data)

  shell.puts(
    format(
      '%-2s %-17s %-17s %-10s %-10s %-5s',
      '',
      'ID',
      'Name',
      'Experience',
      'Glory',
      'Stars'
    )
  )
  data['playerEntries'].each_with_index do |player, i|
    shell.puts(
      format(
        '%-2d %-17d %-17s %-10d %-10d %-5d',
        i + 1,
        player['playerId'],
        player['name'],
        player['exp'],
        player['glory'],
        player['perSeasonStarsCount']
      )
    )
  end
rescue Monolisk::RequestError => e
  shell.puts(e)
end
