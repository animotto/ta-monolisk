# frozen_string_literal: true

require 'json'

## Commands

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

  shell.puts(
    format(
      '%-20s %-5s',
      'ID',
      'Amount'
    )
  )

  cards = data['ownedCards'].sort { |a, b| a['identifier'] <=> b['identifier'] }
  cards.each do |card|
    shell.puts(
      format(
        '%-20s %-5s',
        card['identifier'],
        card['count']
      )
    )
  end
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

  shell.puts(
    format(
      '%-17s %-15s',
      'ID',
      'Name'
    )
  )
  data['playerEntries'].each do |player|
    shell.puts(
      format(
        '%-17s %-15s',
        player['id'],
        player['name']
      )
    )
  end
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

  shell.puts(
    format(
      '%-17s %-15s',
      'ID',
      'Name'
    )
  )
  data['playerEntries'].each do |player|
    shell.puts(
      format(
        '%-17s %-15s',
        player['id'],
        player['name']
      )
    )
  end
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
