# frozen_string_literal: true

require 'json'

## Contexts

CONTEXT_PLAYER_DUNGEON = CONTEXT_PLAYER.add_context(:dungeon, description: 'Player dungeons')

## Player commands

# profile
CONTEXT_PLAYER.add_command(
  :profile,
  description: 'Profile'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.full_player_info
  data = JSON.parse(data)
  profile = Printer::Profile.new(data)
  shell.puts(profile)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# loadouts
CONTEXT_PLAYER.add_command(
  :loadout,
  description: 'Avatars loadout',
  params: ['<avatar>']
) do |tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  avatar = tokens[1].to_i

  data = GAME.api.full_player_info
  data = JSON.parse(data)

  key = "av#{avatar}Loadout"
  unless data['loadouts'].key?(key)
    LOGGER.log('No such avatar')
    next
  end

  data['loadouts'][key]['loadout'].each do |card|
    shell.puts(card)
  end
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# cards
CONTEXT_PLAYER.add_command(
  :cards,
  description: 'Cards'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.full_player_info
  data = JSON.parse(data)

  table = Printer::Table.new(
    'Cards',
    ['ID', 'Amount'],
    data['ownedCards'].map { |c| [c['identifier'], c['count']] }
  )

  shell.puts(table)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# rename
CONTEXT_PLAYER.add_command(
  :rename,
  description: 'Rename',
  params: ['<name>']
) do |tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  LOGGER.log(GAME.api.player_name(tokens[1]))
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# following
CONTEXT_PLAYER.add_command(
  :following,
  description: 'Show the following list'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.full_player_info
  data = JSON.parse(data)
  data = GAME.api.player_followig_list(data['player']['id'])
  data = JSON.parse(data)

  if data['playerEntries'].empty?
    LOGGER.log('The following list is empty')
    next
  end

  table = Printer::Table.new(
    'Following',
    ['ID', 'Name'],
    data['playerEntries'].map { |p| [p['id'], p['name']] }
  )

  shell.puts(table)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# followers
CONTEXT_PLAYER.add_command(
  :followers,
  description: 'Show the followers list'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.full_player_info
  data = JSON.parse(data)
  data = GAME.api.player_followers_list(data['player']['id'])
  data = JSON.parse(data)

  if data['playerEntries'].empty?
    LOGGER.log('The followers list is empty')
    next
  end

  table = Printer::Table.new(
    'Followers',
    ['ID', 'Name'],
    data['playerEntries'].map { |p| [p['id'], p['name']] }
  )

  shell.puts(table)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# follow
CONTEXT_PLAYER.add_command(
  :follow,
  description: 'Add player to the following list',
  params: ['<id>']
) do |tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  id = tokens[1].to_i

  GAME.api.follow_player(id)
  LOGGER.success('OK')
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# unfollow
CONTEXT_PLAYER.add_command(
  :unfollow,
  description: 'Remove player from the following list',
  params: ['<id>']
) do |tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  id = tokens[1].to_i

  GAME.api.unfollow_player(id)
  LOGGER.success('OK')
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

## Dungeon commands

# list
CONTEXT_PLAYER_DUNGEON.add_command(
  :list,
  description: 'Player dungeons'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.player_dungeons
  data = JSON.parse(data)

  dungeons = Printer::PlayerDungeons.new(data)
  shell.puts(dungeons)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end
