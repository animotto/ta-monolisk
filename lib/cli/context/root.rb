# frozen_string_literal: true

## Contexts

# player
CONTEXT_PLAYER = SHELL.add_context(:player, description: 'Player')

# dungeon
CONTEXT_DUNGEON = SHELL.add_context(:dungeon, description: 'Dungeon')

# top
CONTEXT_TOP = SHELL.add_context(:top, description: 'Top players')

# script
CONTEXT_SCRIPT = SHELL.add_context(:script, description: 'Scripts')

## Commands

# connect
SHELL.add_command(
  :connect,
  description: 'Connect'
) do |_tokens, _shell|
  GAME.connect do |request|
    LOGGER.success(request)
  end

  GAME_THREAD.thread&.kill
  GAME_THREAD.thread = Thread.new do
    GAME_THREAD.proc.call(GAME, LOGGER)
  end
rescue Monolisk::InvalidIDError
  LOGGER.fail('Invalid ID')
rescue Monolisk::InvalidPasswordError
  LOGGER.fail('Invalid password')
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
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  list = Printer::List.new(
    'Application settings',
    GAME.app_settings.map(&:key),
    GAME.app_settings.map(&:value)
  )

  shell.puts(list)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# new
SHELL.add_command(
  :new,
  description: 'Create a new player'
) do |_tokens, shell|
  data = GAME.api.create_player
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

  data = GAME.api.player_profile_info(id)
  data = JSON.parse(data)

  if data['player'].nil?
    LOGGER.log('No such player')
    next
  end

  data['player']['level'] = GAME.conversion_tables.exp_to_level(data.dig('player', 'exp'))
  data['starsInfo']['nextReward'] = GAME.conversion_tables.stars_for_next_reward(data.dig('starsInfo', 'totalStarsCount'))

  profile = Printer::Profile.new(data)
  shell.puts(profile)

  next if data['createdDungeons'].empty?

  shell.puts

  dungeons = Printer::Dungeons.new(data['createdDungeons'])
  shell.puts(dungeons)
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

  data = GAME.api.player_profile_info_by_name(name)
  data = JSON.parse(data)

  data['player']['level'] = GAME.conversion_tables.exp_to_level(data.dig('player', 'exp'))
  data['starsInfo']['nextReward'] = GAME.conversion_tables.stars_for_next_reward(data.dig('starsInfo', 'totalStarsCount'))

  profile = Printer::Profile.new(data)
  shell.puts(profile)

  next if data['createdDungeons'].empty?

  shell.puts

  dungeons = Printer::Dungeons.new(data['createdDungeons'])
  shell.puts(dungeons)
rescue Monolisk::UnknownPlayerNameError
  LOGGER.log('No such player')
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end
