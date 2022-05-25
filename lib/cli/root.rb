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

  API.check_session
  shell.puts('OK')
rescue Monolisk::RequestError => e
  shell.puts(e)
end

# settings
SHELL.add_command(
  :settings,
  description: 'Application settings'
) do |_tokens, shell|
  shell.puts(API.app_settings)
rescue Monolisk::RequestError => e
  shell.puts(e)
end

# info
SHELL.add_command(
  :info,
  description: 'Show player profile info',
  params: ['<id>']
) do |tokens, shell|
  unless API.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  id = tokens[1].to_i

  data = API.player_profile_info(id)
  data = JSON.parse(data)

  if data['player'].nil?
    shell.puts('No such player')
    next
  end

  shell.puts(format('%-15s %s', 'ID', data['player']['id']))
  shell.puts(format('%-15s %s', 'Name', data['player']['name']))
  shell.puts(format('%-15s %s', 'Coins', data['player']['coins']))
  shell.puts(format('%-15s %s', 'Experience', data['player']['exp']))
  shell.puts(format('%-15s %s', 'Glory', data['player']['glory']))
  shell.puts(format('%-15s %s', 'Stars', data['starsInfo']['totalStarsCount']))
  shell.puts(format('%-15s %s', 'Dust equipment', data['player']['dust_equipment']))
  shell.puts(format('%-15s %s', 'Dust dungeon', data['player']['dust_dungeonCards']))
  shell.puts(format('%-15s %s', 'Tutorial', data['player']['tutorial']))
rescue Monolisk::RequestError => e
  shell.puts(e)
end
