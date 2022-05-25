# frozen_string_literal: true

require 'json'

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

  shell.puts(
    format(
      '%-1s %-17s %-17s %-17s %-5s %-3s %s',
      '',
      'ID',
      'Owner ID',
      'Owner name',
      'Level',
      'Ver',
      'Name'
    )
  )
  data.each do |dungeon|
    shell.puts(
      format(
        '%-1s %-17d %-17d %-17s %-5d %-3d %s',
        dungeon['canGainGloryHere'] ? '' : "\u00d7",
        dungeon['dungeonInfo']['id'],
        dungeon['dungeonInfo']['ownerId'],
        dungeon['dungeonInfo']['ownerName'],
        dungeon['dungeonInfo']['difficultyLevel'],
        dungeon['dungeonInfo']['versionPublished'],
        dungeon['dungeonInfo']['name']
      )
    )
  end
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

  shell.puts(
    format(
      '%-1s %-17s %-17s %-17s %-5s %-3s %s',
      '',
      'ID',
      'Owner ID',
      'Owner name',
      'Level',
      'Ver',
      'Name'
    )
  )
  data.each do |dungeon|
    shell.puts(
      format(
        '%-1s %-17d %-17d %-17s %-5d %-3d %s',
        dungeon['canGainGloryHere'] ? '' : "\u00d7",
        dungeon['dungeonInfo']['id'],
        dungeon['dungeonInfo']['ownerId'],
        dungeon['dungeonInfo']['ownerName'],
        dungeon['dungeonInfo']['difficultyLevel'],
        dungeon['dungeonInfo']['versionPublished'],
        dungeon['dungeonInfo']['name']
      )
    )
  end
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

  shell.puts(
    format(
      '%-1s %-17s %-17s %-17s %-5s %-3s %s',
      '',
      'ID',
      'Owner ID',
      'Owner name',
      'Level',
      'Ver',
      'Name'
    )
  )
  data.each do |dungeon|
    shell.puts(
      format(
        '%-1s %-17d %-17d %-17s %-5d %-3d %s',
        dungeon['canGainGloryHere'] ? '' : "\u00d7",
        dungeon['dungeonInfo']['id'],
        dungeon['dungeonInfo']['ownerId'],
        dungeon['dungeonInfo']['ownerName'],
        dungeon['dungeonInfo']['difficultyLevel'],
        dungeon['dungeonInfo']['versionPublished'],
        dungeon['dungeonInfo']['name']
      )
    )
  end
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

  shell.puts(
    format(
      '%-1s %-17s %-17s %-17s %-5s %-3s %s',
      '',
      'ID',
      'Owner ID',
      'Owner name',
      'Level',
      'Ver',
      'Name'
    )
  )
  data.each do |dungeon|
    shell.puts(
      format(
        '%-1s %-17d %-17d %-17s %-5d %-3d %s',
        dungeon['canGainGloryHere'] ? '' : "\u00d7",
        dungeon['dungeonInfo']['id'],
        dungeon['dungeonInfo']['ownerId'],
        dungeon['dungeonInfo']['ownerName'],
        dungeon['dungeonInfo']['difficultyLevel'],
        dungeon['dungeonInfo']['versionPublished'],
        dungeon['dungeonInfo']['name']
      )
    )
  end
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

  data['dungeonComments']['comments'].each do |comment|
    shell.puts(
      format(
        '%d. [%s] v%d',
        comment['commentId'],
        comment['date'],
        comment['dungeonVersion']
      )
    )

    shell.puts(
      format(
        '%d %s: %s',
        comment['playerId'],
        comment['playerName'],
        comment['text']
      )
    )

    shell.puts
  end
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

  data['dungeonComments']['comments'].each do |comment|
    shell.puts(
      format(
        '%d. [%s] v%d',
        comment['commentId'],
        comment['date'],
        comment['dungeonVersion']
      )
    )

    shell.puts(
      format(
        '%d %s: %s',
        comment['playerId'],
        comment['playerName'],
        comment['text']
      )
    )

    shell.puts
  end
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

  shell.puts(
    format(
      '%-17s %-17s %-17s %-5s %s',
      'ID',
      'Owner ID',
      'Owner name',
      'Level',
      'Name'
    )
  )
  data.each do |dungeon|
    shell.puts(
      format(
        '%-17d %-17d %-17s %-5d %s',
        dungeon['dungeonChain']['id'],
        dungeon['dungeonChain']['ownerId'],
        dungeon['dungeonChain']['ownerName'],
        dungeon['dungeonChain']['difficultyLevel'],
        dungeon['dungeonChain']['name']
      )
    )
  end
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

  shell.puts(
    format(
      '%-17s %-17s %-17s %-5s %s',
      'ID',
      'Owner ID',
      'Owner name',
      'Level',
      'Name'
    )
  )
  data.each do |dungeon|
    shell.puts(
      format(
        '%-17d %-17d %-17s %-5d %s',
        dungeon['dungeonChain']['id'],
        dungeon['dungeonChain']['ownerId'],
        dungeon['dungeonChain']['ownerName'],
        dungeon['dungeonChain']['difficultyLevel'],
        dungeon['dungeonChain']['name']
      )
    )
  end
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

  shell.puts(
    format(
      '%-17s %-17s %-17s %-5s %s',
      'ID',
      'Owner ID',
      'Owner name',
      'Level',
      'Name'
    )
  )
  data.each do |dungeon|
    shell.puts(
      format(
        '%-17d %-17d %-17s %-5d %s',
        dungeon['dungeonChain']['id'],
        dungeon['dungeonChain']['ownerId'],
        dungeon['dungeonChain']['ownerName'],
        dungeon['dungeonChain']['difficultyLevel'],
        dungeon['dungeonChain']['name']
      )
    )
  end
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

  shell.puts(
    format(
      '%-17s %-17s %-17s %-5s %s',
      'ID',
      'Owner ID',
      'Owner name',
      'Level',
      'Name'
    )
  )
  data['dungeonChains'].each do |dungeon|
    shell.puts(
      format(
        '%-17d %-17d %-17s %-5d %s',
        dungeon['dungeonChain']['id'],
        dungeon['dungeonChain']['ownerId'],
        dungeon['dungeonChain']['ownerName'],
        dungeon['dungeonChain']['difficultyLevel'],
        dungeon['dungeonChain']['name']
      )
    )
  end
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
