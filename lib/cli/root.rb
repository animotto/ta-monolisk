# frozen_string_literal: true

## Contexts

# player
CONTEXT_PLAYER = SHELL.add_context(:player, description: 'Player')

# dungeon
CONTEXT_DUNGEON = SHELL.add_context(:dungeon, description: 'Dungeon')

## Commands

# connect
SHELL.add_command(
  :connect,
  description: 'Connect'
) do |_tokens, shell|
  data = API.login('RU')
  data = JSON.parse(data)
  API.sid = data['sessionId']
  shell.puts('OK')
rescue Monolisk::RequestError => e
  shell.puts(e)
end

# sid
SHELL.add_command(
  :sid,
  description: 'Show session ID'
) do |_tokens, shell|
  unless API.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  shell.puts(API.sid)
end

# check
SHELL.add_command(
  :check,
  description: 'Check the session'
) do |_tokens, shell|
  unless API.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  shell.puts(API.check_session)
rescue Monolisk::RequestError => e
  shell.puts(e)
end

# settings
SHELL.add_command(:settings) do |_tokens, shell|
  shell.puts(API.app_settings)
rescue Monolisk::RequestError => e
  shell.puts(e)
end

# top
SHELL.add_command(
  :top,
  description: 'Top players',
  params: ['<glory|stars>']
) do |tokens, shell|
  unless API.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  case tokens[1]
  when 'glory'
    shell.puts(API.top_players_by_glory)

  when 'stars'
    shell.puts(API.top_players_by_stars)

  else
    shell.puts('Invalid type')
  end
rescue Monolisk::RequestError => e
  shell.puts(e)
end
