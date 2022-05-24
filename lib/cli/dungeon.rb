# frozen_string_literal: true

require 'json'

## Commands

CONTEXT_DUNGEON.add_command(
  :list,
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
      '%-17s %-17s %-17s %-3s %s',
      'ID',
      'Owner ID',
      'Owner name',
      'Ver',
      'Name'
    )
  )
  data.each do |dungeon|
    shell.puts(
      format(
        '%-17d %-17d %-17s %-3d %s',
        dungeon['dungeonInfo']['id'],
        dungeon['dungeonInfo']['ownerId'],
        dungeon['dungeonInfo']['ownerName'],
        dungeon['dungeonInfo']['versionPublished'],
        dungeon['dungeonInfo']['name']
      )
    )
  end
rescue Monolisk::RequestError => e
  shell.puts(e)
end
