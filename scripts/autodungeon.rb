# frozen_string_literal: true

##
# Auto dungeon playthrough

require 'securerandom'

OPTIONS = {
  n: 'Amount of dungeons',
  s: 'Sleep time',
  avatar: 'Avatar',
  glory: 'Glory'
}.freeze

GLORY_RANDOM = (300..1500).freeze
UNITS_GLORY_RANDOM = (20..300).freeze
GLORY_MULTIPLIER_RANDOM = (1.1..5.0).freeze
TIME_RANDOM = (45.0..75.0).freeze
TIME_HOT_RANDOM = (15.0..25.0).freeze
TIME_WARM_RANDOM = (5.0..10.0).freeze
HP_RANDOM = (35..100).freeze
AVATAR_RANDOM = (1..5).freeze
CREATURES_KILLED_RANDOM = (5..20).freeze
OBJECTS_DESTROYED_RANDOM = (5..20).freeze
ABILITIES_CAST_RANDOM = (10..30).freeze
DASHES_PERFORMED_RANDOM = (0..5).freeze
HEALTH_COLLECTED_RANDOM = (1..5).freeze
MANA_COLLECTED_RANDOM = (1..5).freeze
DISTANCE_TOTAL_RANDOM = (80.0..100.0).freeze
DISTANCE_HOT_RANDOM = (10.0..20.0).freeze
DISTANCE_WARM_RANDOM = (10.0..20.0).freeze
CHALLENGES = [1, 2, 6, 26].freeze
RATING_RANDOM = (1..3).freeze
RATE_TIME = 2
CLAIM_TIME = 2
INTERVAL_RANDOM = (3..10).freeze

def start
  unless @game.connected?
    @logger.fail(NOT_CONNECTED)
    return
  end

  if @args.length.zero? || @args.length.odd?
    print_usage
    return
  end

  options = {}
  0.step((@args.length - 1), 2) do |i|
    option = @args[i].delete_prefix('-').to_sym
    unless OPTIONS.key?(option)
      options.clear
      break
    end

    options[option] = @args[i + 1].to_i
  end

  if options.empty?
    print_usage
    return
  end

  unless options.key?(:n)
    @logger.info('Specify amount of dungeons')
    return
  end

  dungeons = find_dungeons(options[:n]) do |source, n|
    @logger.info("Got #{n} dungeons from #{source}")
  end

  if dungeons.empty?
    @logger.fail('Dungeons not found')
    return
  end

  dungeons.each_with_index do |dungeon, i|
    break if i + 1 > options[:n]

    owner_id = dungeon.dig('dungeonInfo', 'ownerId')
    dungeon_id = dungeon.dig('dungeonInfo', 'id')

    dungeon_data = @game.api.start_dungeon(owner_id, dungeon_id)
    dungeon_data = JSON.parse(dungeon_data)
    @logger.success(
      Kernel.format(
        'Start dungeon %d (%s / %s)',
        dungeon_id,
        dungeon.dig('dungeonInfo', 'ownerName'),
        dungeon.dig('dungeonInfo', 'name')
      )
    )

    coins = dungeon_data.dig('playedDungeon', 'coins')
    coins *= -1 if coins.negative?

    if options.key?(:glory)
      glory = options[:glory]
    else
      glory = dungeon_data.dig('dungeonContent', 'dungeonInfo', 'predictedGlory').round
      if glory.negative?
        @logger.info('Glory is negative, generating a random value')
        glory = SecureRandom.rand(GLORY_RANDOM)
      end
    end

    avatar = options[:avatar] || SecureRandom.rand(AVATAR_RANDOM)
    hp = SecureRandom.rand(HP_RANDOM)
    creatures_killed = SecureRandom.rand(CREATURES_KILLED_RANDOM)
    objects_destroyed = SecureRandom.rand(OBJECTS_DESTROYED_RANDOM)
    abilities_cast = SecureRandom.rand(ABILITIES_CAST_RANDOM)
    dashes_performed = SecureRandom.rand(DASHES_PERFORMED_RANDOM)
    health_collected = SecureRandom.rand(HEALTH_COLLECTED_RANDOM)
    mana_collected = SecureRandom.rand(MANA_COLLECTED_RANDOM)
    units_glory = SecureRandom.rand(UNITS_GLORY_RANDOM).to_f
    glory_multiplier = SecureRandom.rand(GLORY_MULTIPLIER_RANDOM).round(8)

    distance_total = SecureRandom.rand(DISTANCE_TOTAL_RANDOM).round(8)
    distance_hot = SecureRandom.rand(DISTANCE_HOT_RANDOM).round(8)
    distance_warm = SecureRandom.rand(DISTANCE_WARM_RANDOM).round(8)

    time = SecureRandom.rand(TIME_RANDOM).round(8)
    time_hot = SecureRandom.rand(TIME_HOT_RANDOM).round(8)
    time_warm = SecureRandom.rand(TIME_WARM_RANDOM).round(8)

    challenges = {}
    CHALLENGES.each do |challenge|
      challenges[challenge] = 1
    end

    @logger.info("Coins: #{coins}, Glory: #{glory}, Avatar: #{avatar}, Time: #{time}")

    details = {
      'appVersion' => @game.api.client.version,
      'success' => true,
      'numCoinsCollected' => coins,
      'timeInSeconds' => time.round,
      'finishHpPerc' => hp,
      'allCreaturesKilled' => true,
      'numCreaturesKilled' => creatures_killed,
      'numObjectsDestroyed' => objects_destroyed,
      'numDashesPerformed' => dashes_performed,
      'numAbilitiesCast' => abilities_cast,
      'numHealthOrbsCollected' => health_collected,
      'numManaOrbsCollected' => mana_collected,
      'numHostileUnitsOriginallyPlaced' => creatures_killed,
      'numHostileUnitsOriginallyPlacedLeftAlive' => 0,
      'rawSpawnedUnitsGlory' => units_glory,
      'rawDiedUnitsGlory' => units_glory,
      'gloryMultiplier' => glory_multiplier,
      'challengesFulfilled' => challenges,
      'avatarUsed' => avatar,
      'distanceTraveledTotal' => distance_total,
      'distanceTraveletHot' => distance_hot,
      'distanceTraveletWarm' => distance_warm,
      'timeTotal' => time,
      'timeHot' => time_hot,
      'timeWarm' => time_warm,
      'cumulatedClampedAggroDist' => 4.868336,
      'cumulatedUnclampedAggroDist' => 4.868336,
      'firstTimeAggrosCount' => 12,
      'numberOfEncounters' => 2,
      'cumulatedClampedEncountersDist' => 1.8683362,
      'cumulatedUnclampedEncountersDist' => 1.8683362,
      'countOfUnitsInEncounters' => 12,
      'rawGloryInEncounters' => 36.0,
      'maxCountOfUnitsInEncounter' => 10,
      'maxRawGloryInEncounter' => 32.0,
      'totalDefaultPlacementPrice' => 29,
      'defaultPlacementPriceInEncounters' => 29,
      'maxDefaultPlacementPriceInEncounter' => 25,
      'totalCoinDroppingObjectsCount' => 15,
      'unreachableCoinDroppingObjectsCount' => 0,
      'encountersUnitsCounts' => [10, 2],
      'encountersDefaultPlacementPrice' => [25, 4],
      'encountersRawGlory' => [32.0, 4.0],
      'gloryGained' => glory
    }

    details = JSON.generate(details)

    Kernel.sleep(options[:s] || time)
    finish_data = @game.api.finish_dungeon(owner_id, dungeon_id, details)
    finish_data = JSON.parse(finish_data)
    @logger.success('Finish dungeon')

    unless finish_data['starterCardsReward'].nil?
      @logger.info("Starter cards reward: #{finish_data['starterCardsReward'].join(', ')}")
      Kernel.sleep(CLAIM_TIME)
      card = finish_data['starterCardsReward'].sample
      @game.api.claim_starter_cards_reward(card)
      @logger.success("Claim starter card reward: #{card}")
    end

    Kernel.sleep(RATE_TIME)
    rating = SecureRandom.rand(RATING_RANDOM)
    @game.api.rate_dungeon(owner_id, dungeon_id, rating)
    @logger.success("Rate dungeon with #{rating} rating")

    Kernel.sleep(SecureRandom.rand(INTERVAL_RANDOM)) if i + 1 < options[:n]
  end

  @logger.success('Done')
rescue Monolisk::DungeonNotFoundError
  @logger.fail('No such dungeon')
rescue Monolisk::RequestError => e
  @logger.fail(e)
end

def find_dungeons(amount)
  dungeons = []

  data = @game.api.suitable_dungeons
  data = JSON.parse(data)
  list = data.select { |d| d['canGainGloryHere'] }
  yield('suitable dungeons', list.length)
  dungeons += list
  return dungeons if dungeons.length >= amount

  data = @game.api.newest_dungeons
  data = JSON.parse(data)
  list = data.select { |d| d['canGainGloryHere'] && d.dig('dungeonInfo', 'published') }
  yield('newest dungeons', list.length)
  dungeons += list
  return dungeons if dungeons.length >= amount

  data = @game.api.featured_dungeons
  data = JSON.parse(data)
  list = data.select { |d| d['canGainGloryHere'] }
  yield('featured dungeons', list.length)
  dungeons += list
  return dungeons if dungeons.length >= amount

  data = @game.api.dungeons_from_follow
  data = JSON.parse(data)
  list = data.select { |d| d['canGainGloryHere'] }
  yield('following dungeons', list.length)
  dungeons += list
  return dungeons if dungeons.length >= amount

  players = @game.api.top_players_by_stars
  players = JSON.parse(players)
  list = []
  players['playerEntries'].each do |player|
    info = @game.api.player_profile_info(player['playerId'])
    info = JSON.parse(info)
    next if info['createdDungeons'].empty?

    list += info['createdDungeons'].select { |d| d['canGainGloryHere'] && d.dig('dungeonInfo', 'published') }
    break if dungeons.length + list.length >= amount
  end

  yield('top stars dungeons', list.length)
  dungeons + list
end

def print_usage
  @shell.puts('Usage: autodungeon <options>')
  @shell.puts('Options:')
  OPTIONS.each do |k, v|
    @shell.puts(Kernel.format(' -%-15s  %s', k, v))
  end
end
