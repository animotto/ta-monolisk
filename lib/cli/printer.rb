# frozen_string_literal: true

module Printer
  ##
  # List
  class List
    def initialize(header, titles, items)
      @header = header
      @titles = titles
      @items = items

      raise ArgumentError, 'The length of the title and item arrays is not equal' if @titles.length != @items.length
    end

    def to_s
      title_length = @titles.inject(0) { |a, t| t.length > a ? t.length : a }
      list = ["\e[1;35m\u2022 #{@header}\e[0m"]
      @titles.each_with_index do |title, i|
        list << Kernel.format(
          "  \e[35m%-#{title_length}s\e[0m  %s",
          title,
          @items[i]
        )
      end

      list.join("\n")
    end
  end

  ##
  # Table
  class Table
    def initialize(header, titles, items, selected = [])
      @header = header
      @titles = titles
      @items = items
      @selected = selected

      @items.each do |item|
        raise ArgumentError, 'The length of the title and item arrays is not equal' if @titles.length != item.length
      end
    end

    def to_s
      table = ["\e[1;35m\u2022 #{@header}\e[0m"]

      column_length = @titles.map(&:length)
      @items.each do |item|
        item.each_with_index do |col, i|
          length = col.to_s.length
          column_length[i] = length if length > column_length[i]
        end
      end

      titles = []
      @titles.each_with_index do |title, i|
        titles << Kernel.format(
          "\e[35m%-#{column_length[i]}s\e[0m",
          title
        )
      end
      table << titles.join(' ').prepend('  ')

      @items.each.with_index do |item, i|
        row = []
        item.each_with_index do |col, j|
          row << Kernel.format(
            "%-#{column_length[j]}s",
            col
          )
        end
        row = row.join(' ').prepend('  ')
        row = "\e[37;45m#{row}\e[0m" if @selected.include?(i)
        table << row
      end

      table.join("\n")
    end
  end

  ##
  # Base printer
  class BasePrinter
    def initialize(data)
      @data = data
    end
  end

  ##
  # Profile
  class Profile < BasePrinter
    def to_s
      List.new(
        'Profile',
        [
          'ID',
          'Name',
          'Coins',
          'Experience',
          'Level',
          'Glory',
          'Stars',
          'Dust equipment',
          'Dust dungeon',
          'Tutorial'
        ],
        [
          @data.dig('player', 'id'),
          @data.dig('player', 'name'),
          @data.dig('player', 'coins'),
          @data.dig('player', 'exp'),
          @data.dig('player', 'level'),
          @data.dig('player', 'glory'),
          @data.dig('starsInfo', 'totalStarsCount'),
          @data.dig('player', 'dust_equipment'),
          @data.dig('player', 'dust_dungeonCards'),
          @data.dig('player', 'tutorial')
        ]
      ).to_s
    end
  end

  ##
  # Dungeons
  class Dungeons < BasePrinter
    def to_s
      Table.new(
        'Dungeons',
        ['?', 'ID', 'Owner ID', 'Owner name', 'Dif', 'Ver', 'Name'],
        @data.map do |d|
          [
            d['canGainGloryHere'] ? '' : "\u2713",
            d.dig('dungeonInfo', 'id'),
            d.dig('dungeonInfo', 'ownerId'),
            d.dig('dungeonInfo', 'ownerName'),
            d.dig('dungeonInfo', 'difficultyLevel'),
            d.dig('dungeonInfo', 'versionPublished'),
            d.dig('dungeonInfo', 'name')
          ]
        end
      ).to_s
    end
  end

  ##
  # Dungeon chains
  class DungeonChains < BasePrinter
    def to_s
      Table.new(
        'Dungeon chains',
        ['ID', 'Owner ID', 'Owner name', 'Dif', 'Name'],
        @data.map do |d|
          [
            d.dig('dungeonChain', 'id'),
            d.dig('dungeonChain', 'ownerId'),
            d.dig('dungeonChain', 'ownerName'),
            d.dig('dungeonChain', 'difficultyLevel'),
            d.dig('dungeonChain', 'name')
          ]
        end
      ).to_s
    end
  end

  ##
  # Comments
  class Comments < BasePrinter
    def to_s
      comments = []
      @data.dig('dungeonComments', 'comments').each do |comment|
        comments << Kernel.format(
          "\e[36m%d [%s] v%d\e[0m",
          comment['commentId'],
          comment['date'],
          comment['dungeonVersion']
        )

        comments << Kernel.format(
          "\e[35m%s (%d) \e[33m%s\e[0m",
          comment['playerName'],
          comment['playerId'],
          comment['text']
        )

        comments << ''
      end

      comments.join("\n")
    end
  end

  ##
  # Player dungeons
  class PlayerDungeons < BasePrinter
    def to_s
      Table.new(
        'Dungeons',
        ['ID', 'Dif', 'Ver', 'Name'],
        @data.map do |d|
          [
            d['id'],
            d['difficultyLevel'],
            d['versionPublished'],
            d['name']
          ]
        end
      ).to_s
    end
  end
end
