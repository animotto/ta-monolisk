# frozen_string_literal: true

require 'json'

## Contexts

# player
CONTEXT_PLAYER = SHELL.add_context(:player, description: 'Player')

# dungeon
CONTEXT_DUNGEON = SHELL.add_context(:dungeon, description: 'Dungeon')

# top
CONTEXT_TOP = SHELL.add_context(:top, description: 'Top players')

## Commands

# connect
SHELL.add_command(
  :connect,
  description: 'Authentication by ID and password'
) do |_tokens, _shell|
  GAME.connect
  LOGGER.success('OK')

  GAME_THREAD.thread&.kill
  GAME_THREAD.thread = Thread.new do
    GAME_THREAD.proc.call(GAME, LOGGER)
  end
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# disconnect
SHELL.add_command(
  :disconnect,
  description: 'Erase the session ID'
) do |_tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  GAME.disconnect
  LOGGER.success('OK')

  GAME_THREAD.thread&.kill
end

# sid
SHELL.add_command(
  :sid,
  description: 'Show session ID'
) do |_tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  LOGGER.log(GAME.api.sid)
end

# check
SHELL.add_command(
  :check,
  description: 'Check the session'
) do |_tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  GAME.api.check_session
  LOGGER.success('OK')
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# settings
SHELL.add_command(
  :settings,
  description: 'Application settings'
) do |_tokens, _shell|
  LOGGER.log(GAME.api.app_settings)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# new
SHELL.add_command(
  :new,
  description: 'Create a new player'
) do |_tokens, shell|
  data = API.create_player
  data = JSON.parse(data)

  list = Printer::List.new(
    'New account',
    ['ID', 'Password', 'Session ID'],
    [data['id'], data['password'], data['sessionId']]
  )

  shell.puts(list)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# info
SHELL.add_command(
  :info,
  description: 'Show player profile info',
  params: ['<id>']
) do |tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  id = tokens[1].to_i

  data = API.player_profile_info(id)
  data = JSON.parse(data)

  if data['player'].nil?
    LOGGER.log('No such player')
    next
  end

  profile = Printer::Profile.new(data)
  shell.puts(profile)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# search
SHELL.add_command(
  :search,
  description: 'Search player by name',
  params: ['<name>']
) do |tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  name = tokens[1]

  data = API.player_profile_info_by_name(name)
  data = JSON.parse(data)

  profile = Printer::Profile.new(data)
  shell.puts(profile)
rescue Monolisk::UnknownPlayerNameError
  LOGGER.log('No such player')
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end
