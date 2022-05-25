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

  shell.puts(format('%-15s %s', 'ID', data['id']))
  shell.puts(format('%-15s %s', 'Password', data['password']))
  shell.puts(format('%-15s %s', 'Session ID', data['sessionId']))
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# info
SHELL.add_command(
  :info,
  description: 'Show player profile info',
  params: ['<id>']
) do |tokens, shell|
  unless API.connected?
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

  shell.puts(format('%-15s %s', 'ID', data['player']['id']))
  shell.puts(format('%-15s %s', 'Name', data['player']['name']))
  shell.puts(format('%-15s %s', 'Coins', data['player']['coins']))
  shell.puts(format('%-15s %s', 'Experience', data['player']['exp']))
  shell.puts(format('%-15s %s', 'Glory', data['player']['glory']))
  shell.puts(format('%-15s %s', 'Stars', data['starsInfo']['totalStarsCount'])) unless data['starsInfo'].nil?
  shell.puts(format('%-15s %s', 'Dust equipment', data['player']['dust_equipment']))
  shell.puts(format('%-15s %s', 'Dust dungeon', data['player']['dust_dungeonCards']))
  shell.puts(format('%-15s %s', 'Tutorial', data['player']['tutorial']))
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# search
SHELL.add_command(
  :search,
  description: 'Search player by name',
  params: ['<name>']
) do |tokens, shell|
  unless API.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  name = tokens[1]

  data = API.player_profile_info_by_name(name)
  data = JSON.parse(data)

  if data['player'].nil?
    LOGGER.log('No such player')
    next
  end

  shell.puts(format('%-15s %s', 'ID', data['player']['id']))
  shell.puts(format('%-15s %s', 'Name', data['player']['name']))
  shell.puts(format('%-15s %s', 'Coins', data['player']['coins']))
  shell.puts(format('%-15s %s', 'Experience', data['player']['exp']))
  shell.puts(format('%-15s %s', 'Glory', data['player']['glory']))
  shell.puts(format('%-15s %s', 'Stars', data['starsInfo']['totalStarsCount'])) unless data['starsInfo'].nil?
  shell.puts(format('%-15s %s', 'Dust equipment', data['player']['dust_equipment']))
  shell.puts(format('%-15s %s', 'Dust dungeon', data['player']['dust_dungeonCards']))
  shell.puts(format('%-15s %s', 'Tutorial', data['player']['tutorial']))
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end
