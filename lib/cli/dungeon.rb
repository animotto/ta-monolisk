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
  unless API.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  data = API.suitable_dungeons
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
  shell.puts(e)
end

# newest
CONTEXT_DUNGEON.add_command(
  :newest,
  description: 'Show newest dungeons'
) do |_tokens, shell|
  unless API.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  data = API.newest_dungeons
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
  shell.puts(e)
end

# featured
CONTEXT_DUNGEON.add_command(
  :featured,
  description: 'Show featured dungeons'
) do |_tokens, shell|
  unless API.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  data = API.featured_dungeons
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
  shell.puts(e)
end

## Dungeon chains commands

# suitable
CONTEXT_DUNGEON_CHAIN.add_command(
  :suitable,
  description: 'Show suitable dungeon chains'
) do |_tokens, shell|
  unless API.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  data = API.suitable_dungeon_chains
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
  shell.puts(e)
end

# newest
CONTEXT_DUNGEON_CHAIN.add_command(
  :newest,
  description: 'Show newest dungeon chains'
) do |_tokens, shell|
  unless API.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  data = API.newest_dungeon_chains
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
  shell.puts(e)
end

# featured
CONTEXT_DUNGEON_CHAIN.add_command(
  :featured,
  description: 'Show featured dungeon chains'
) do |_tokens, shell|
  unless API.connected?
    shell.puts(NOT_CONNECTED)
    next
  end

  data = API.featured_dungeon_chains
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
  shell.puts(e)
end
