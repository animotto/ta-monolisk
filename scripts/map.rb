# frozen_string_literal: true

##
# Dungeon map

OBJECTS = {
  'dungeonentrance' => "\e[32m\u2193\e[0m",
  'dungeonexit' => "\e[32m\u2191\e[0m",
  'unit' => "\e[31m\u25aa\e[0m",
  'wall' => "\e[33m\u25ae\e[0m",
  'door' => "\e[33m\u25ad\e[0m",
  'column' => "\e[33m\u25af\e[0m",
  'light' => "\e[33m\u25ca\e[0m",
  'sign' => "\e[33m\u25c8\e[0m",
  'barrel' => "\e[35m\u25c6\e[0m",
  'chest' => "\e[36m\u25a8\e[0m",
  'stairs' => "\e[34m\u219d\e[0m",
  'trap' => "\e[31m\u25b0\e[0m",
  'object' => "\e[35m\u25cc\e[0m",
  'floor' => ' ',
  default: "\e[30m\u25e6\e[0m"
}.freeze

def start
  unless @game.connected?
    @logger.fail(NOT_CONNECTED)
    return
  end

  if @args[0].nil?
    @logger.info('Specify dungeon ID')
    return
  end

  dungeon = @game.api.dungeon_for_editing(@args[0].to_i)
  dungeon = JSON.parse(dungeon)
  data = dungeon.dig('dungeonContent_underConstruction', 'serializedDungeon')
  data = JSON.parse(data)

  layer1 = data['verticalLayers'].detect { |l| l['y'] == -1 }
  layer2 = data['verticalLayers'].detect { |l| l['y'].zero? }
  layer3 = data['verticalLayers'].detect { |l| l['y'] == 1 }

  minx = []
  maxx = []
  miny = []
  maxy = []
  layer1['objs'].each do |o|
    minx << o['t'].min_by { |t| t[0] }[0]
    maxx << o['t'].max_by { |t| t[0] }[0]
    miny << o['t'].min_by { |t| t[1] }[1]
    maxy << o['t'].max_by { |t| t[1] }[1]
  end
  minx = minx.min
  maxx = maxx.max
  miny = miny.min
  maxy = maxy.max

  width = minx.abs + maxx + 1
  height = miny.abs + maxy + 1
  map = Array.new(width * height, ' ')

  objects = layer2['objs']
  objects += layer3['objs'] unless layer3.nil?
  objects.each do |object|
    s = OBJECTS.detect { |k, _| object['id'] =~ /^#{Regexp.escape(k)}/ }
    s = s.nil? ? OBJECTS[:default] : s[1]

    object['t'].each do |t|
      x = t[0] + minx.abs
      y = ((t[1] + miny.abs) * -1) - 1
      i = (y * width) + x
      map[i] = s
    end
  end

  layer1['objs'].each do |object|
    object['t'].each do |t|
      x = t[0] + minx.abs
      y = ((t[1] + miny.abs) * -1) - 1
      i = (y * width) + x
      next if map[i].empty?

      map[i] = "\e[47m#{map[i]}\e[0m"
    end
  end

  height.times do |i|
    line = map[(i * width)..((i * width) + width - 1)].join
    @shell.puts(line)
  end
rescue Monolisk::RequestError => e
  @logger.fail(e)
end
