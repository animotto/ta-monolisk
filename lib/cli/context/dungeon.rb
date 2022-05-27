# frozen_string_literal: true

## Contexts

CONTEXT_DUNGEON_CHAIN = CONTEXT_DUNGEON.add_context(:chain, description: 'Chains')

## Dungeon commands

# suitable
CONTEXT_DUNGEON.add_command(
  :suitable,
  description: 'Show suitable dungeons'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.suitable_dungeons
  data = JSON.parse(data)

  dungeons = Printer::Dungeons.new(data)
  shell.puts(dungeons)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# newest
CONTEXT_DUNGEON.add_command(
  :newest,
  description: 'Show newest dungeons'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.newest_dungeons
  data = JSON.parse(data)

  dungeons = Printer::Dungeons.new(data)
  shell.puts(dungeons)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# featured
CONTEXT_DUNGEON.add_command(
  :featured,
  description: 'Show featured dungeons'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.featured_dungeons
  data = JSON.parse(data)

  dungeons = Printer::Dungeons.new(data)
  shell.puts(dungeons)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# following
CONTEXT_DUNGEON.add_command(
  :following,
  description: 'Show dungeons from players you follow'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.dungeons_from_follow
  data = JSON.parse(data)

  dungeons = Printer::Dungeons.new(data)
  shell.puts(dungeons)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# comments
CONTEXT_DUNGEON.add_command(
  :comments,
  description: 'Dungeon comments',
  params: ['<id>']
) do |tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  dungeon = tokens[1].to_i

  data = GAME.api.dungeon_comments(0, dungeon)
  data = JSON.parse(data)

  if data['dungeonComments'].nil?
    LOGGER.log('No comments')
    next
  end

  comments = Printer::Comments.new(data)
  shell.puts(comments)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# write
CONTEXT_DUNGEON.add_command(
  :write,
  description: 'Write a comment for the dungeon',
  params: ['<owner>', '<id>', '<ver>', '<avatar>', '<text>']
) do |tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  owner = tokens[1].to_i
  dungeon = tokens[2].to_i
  version = tokens[3].to_i
  avatar = tokens[4].to_i
  text = tokens[5]

  data = GAME.api.add_dungeon_comment(owner, dungeon, version, avatar, text)
  data = JSON.parse(data)

  comments = Printer::Comments.new(data)
  shell.puts(comments)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# rate
CONTEXT_DUNGEON.add_command(
  :rate,
  description: 'Rate the dungeon',
  params: ['<owner>', '<id>', '<rating>']
) do |tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  owner = tokens[1].to_i
  id = tokens[2].to_i
  rating = tokens[3].to_i

  LOGGER.log(GAME.api.rate_dungeon(owner, id, rating))
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

## Dungeon chains commands

# suitable
CONTEXT_DUNGEON_CHAIN.add_command(
  :suitable,
  description: 'Show suitable dungeon chains'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.suitable_dungeon_chains
  data = JSON.parse(data)

  chains = Printer::DungeonChains.new(data)
  shell.puts(chains)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# newest
CONTEXT_DUNGEON_CHAIN.add_command(
  :newest,
  description: 'Show newest dungeon chains'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.newest_dungeon_chains
  data = JSON.parse(data)

  chains = Printer::DungeonChains.new(data)
  shell.puts(chains)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# featured
CONTEXT_DUNGEON_CHAIN.add_command(
  :featured,
  description: 'Show featured dungeon chains'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.featured_dungeon_chains
  data = JSON.parse(data)

  chains = Printer::DungeonChains.new(data)
  shell.puts(chains)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# later
CONTEXT_DUNGEON_CHAIN.add_command(
  :later,
  description: 'Show dungeon chains marked as "play later"'
) do |_tokens, shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  data = GAME.api.dungeon_chains_play_later
  data = JSON.parse(data)

  if data['dungeonChains'].empty?
    LOGGER.log('No dungeon chains')
    next
  end

  chains = Printer::DungeonChains.new(data)
  shell.puts(chains)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# current
CONTEXT_DUNGEON_CHAIN.add_command(
  :current,
  description: 'Show currently played dungeon chain'
) do |_tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  LOGGER.log(GAME.api.currently_played_dungeon_chain)
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end

# rate
CONTEXT_DUNGEON_CHAIN.add_command(
  :rate,
  description: 'Rate the dungeon chain',
  params: ['<owner>', '<id>', '<rating>']
) do |tokens, _shell|
  unless GAME.connected?
    LOGGER.log(NOT_CONNECTED)
    next
  end

  owner = tokens[1].to_i
  id = tokens[2].to_i
  rating = tokens[3].to_i

  LOGGER.log(GAME.api.rate_dungeon_chain(owner, id, rating))
rescue Monolisk::RequestError => e
  LOGGER.fail(e)
end
