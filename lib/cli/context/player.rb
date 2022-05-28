# frozen_string_literal: true

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

# goals
CONTEXT_PLAYER.add_command(
  :goals,
  description: 'Goals'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.full_player_info
  data = JSON.parse(data)

  goals = []
  3.times do |i|
    goal = "goal#{i + 1}"
    type = data.dig('dailyGoals', "#{goal}Type")
    goal_type = GAME.goal_types['allDailyGoalDetails'].detect { |g| g['type'] == type }
    record = data.dig('dailyGoals', "#{goal}Record")
    record = [record, goal_type['targetValue']].join(' / ')
    goals << [
      type,
      goal_type['typeName'],
      record,
      data.dig('dailyGoals', "#{goal}Timer"),
      goal_type['coinsReward']
    ]
  end

  table = Printer::Table.new(
    'Goals',
    ['Type', 'Name', 'Record', 'Timer', 'Coins'],
    goals
  )

  shell.puts(table)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# discard
CONTEXT_PLAYER.add_command(
  :discard,
  description: 'Discard the goal',
  params: ['<type>']
) do |tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  type = tokens[1].to_i

  GAME.api.discard_daily_goal(type)
  LOGGER.success('OK')
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# avatars
CONTEXT_PLAYER.add_command(
  :avatars,
  description: 'Avatars'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.full_player_info
  data = JSON.parse(data)

  if data.dig('player', 'avatarsProgress').nil?
    LOGGER.log('No avatars progress')
    next
  end

  avatars = []
  5.times do |i|
    avatars << [
      i + 1,
      data.dig('player', 'avatarsProgress', 'skillPoints')[i],
      data.dig('player', 'avatarsProgress', 'gloryNow')[i]
    ]
  end

  table = Printer::Table.new(
    'Avatars',
    ['ID', 'Skills', 'Glory'],
    avatars
  )

  shell.puts(table)
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

# packs
CONTEXT_PLAYER.add_command(
  :packs,
  description: 'Card packs'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.full_player_info
  data = JSON.parse(data)

  table = Printer::Table.new(
    'Card packs',
    ['Type', 'Amount'],
    data['ownedPacks'].map { |p| [p['identifier'], p['countAvailable']] }
  )

  shell.puts(table)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# purchase
CONTEXT_PLAYER.add_command(
  :purchase,
  description: 'Purchase a card pack',
  params: ['<type>']
) do |tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  type = tokens[1].to_i

  player = GAME.api.full_player_info
  player = JSON.parse(player)

  GAME.api.purchase_cards_pack_with_coins(type, player.dig('player', 'coins'))
  LOGGER.success('OK')
rescue Monolisk::NotEnoughCoinsError
  LOGGER.fail('Not enough coins')
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# unpack
CONTEXT_PLAYER.add_command(
  :unpack,
  description: 'Unpack card pack',
  params: ['<type>']
) do |tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  type = tokens[1].to_i

  player = GAME.api.full_player_info
  player = JSON.parse(player)

  pack = player['ownedPacks'].detect { |p| p['identifier'] == type }
  if pack.nil?
    LOGGER.fail('Pack type not found')
    next
  end

  data = GAME.api.unpack_cards_pack(type, pack['countAvailable'])
  data = JSON.parse(data)

  table = Printer::Table.new(
    'Cards',
    ['ID', 'Amount'],
    data['cards'].map { |c| [c['identifier'], c['count']] }
  )

  shell.puts(table)
rescue Monolisk::NothingToUnpackError
  LOGGER.fail('Nothing to unpack')
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# sell
CONTEXT_PLAYER.add_command(
  :sell,
  description: 'Sell all duplicates'
) do |_tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  GAME.api.sell_all_duplicates
  LOGGER.success('OK')
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

  GAME.api.player_name(tokens[1])
  LOGGER.success('OK')
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
