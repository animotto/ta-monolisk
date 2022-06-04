# frozen_string_literal: true

module Monolisk
  ##
  # API
  class API
    COMMANDS = {
      app_settings: 'get_app_settings',
      login: 'log_in',
      login_service: 'attempt_logging_in_using_login_service',
      link_login_service: 'link_login_service',
      add_push_notifications_token: 'add_push_notifications_token',
      player_id_from_name: 'get_player_id_from_name',
      full_player_info: 'get_full_player_info',
      check_session: 'check_session',
      twitch_info: 'get_twitch_info',
      tutorial_phase: 'set_player_tutorial_phase',
      suitable_dungeons: 'get_suitable_dungeons_for_player',
      dungeons_from_follow: 'get_dungeons_from_people_i_follow',
      newest_dungeons: 'get_newest_dungeons',
      featured_dungeons: 'get_featured_dungeons',
      suitable_dungeon_chains: 'get_suitable_dungeon_chains_for_player',
      newest_dungeon_chains: 'get_newest_dungeon_chains',
      featured_dungeon_chains: 'get_featured_dungeon_chains',
      start_dungeon: 'start_dungeon',
      start_random_dungeon: 'start_random_dungeon',
      start_dungeon_chain: 'start_dungeon_chain',
      start_next_dungeon_currently_played_dungeon_chain: 'start_next_dungeon_in_currently_played_dungeon_chain',
      finish_dungeon: 'dungeon_finished',
      finish_dungeon_from_dungeon_chain: 'dungeon_from_dungeon_chain_finished',
      rate_dungeon: 'rate_dungeon',
      rate_dungeon_chain: 'rate_dungeon_chain',
      dungeon_chains_play_later: 'get_play_later_dungeon_chains',
      remove_dungeon_chain_play_later: 'remove_dungeon_chain_from_play_later',
      currently_played_dungeon_chain: 'get_currently_played_dungeon_chain',
      dungeon_comments: 'get_dungeon_comments',
      dungeon_chain_comments: 'get_dungeon_chain_comments',
      add_dungeon_comment: 'add_dungeon_comment',
      add_dungeon_chain_comment: 'add_dungeon_chain_comment',
      player_name: 'set_player_name',
      discard_daily_goal: 'discard_daily_goal',
      top_players_by_glory: 'get_top_players_by_glory',
      top_players_by_stars: 'get_top_players_by_stars',
      player_profile_info: 'get_player_profile_info',
      player_profile_info_by_name: 'get_player_profile_info_by_name',
      save_avatar_loadout: 'save_avatar_loadout',
      save_avatar_passives: 'save_avatar_passives',
      claim_starter_cards_reward: 'claim_starter_cards_reward',
      claim_seasonal_rank_rewards: 'claim_seasonal_rank_rewards',
      purchase_cards_pack_with_coins: 'purchase_cards_pack_with_coins',
      purchase_card_with_dust: 'purchase_card_with_dust',
      unpack_cards_pack: 'unpack_cards_pack',
      subscribe_email: 'subscribe_using_email',
      sell_all_duplicates: 'sell_all_equipment_duplicates_for_dust',
      mark_new_cards_viewed: 'mark_new_cards_as_viewed',
      cross_platform_new_code: 'get_new_cross_platform_connect_code',
      player_dungeons: 'list_players_own_dungeons',
      player_followig_list: 'get_players_following_list',
      player_followers_list: 'get_players_followers_list',
      follow_player: 'follow_player',
      unfollow_player: 'unfollow_player',
      create_player: 'create_player',
      localizations: 'get_localizations',
      ccgi_properties_body: 'get_all_ccgi_properties_of_type_body_equipment',
      ccgi_properties_hands: 'get_all_ccgi_properties_of_type_hands_equipment',
      ccgi_properties_head: 'get_all_ccgi_properties_of_type_head_equipment',
      ccgi_properties_legs: 'get_all_ccgi_properties_of_type_legs_equipment',
      ccgi_properties_neck: 'get_all_ccgi_properties_of_type_neck_equipment',
      ccgi_properties_primary: 'get_all_ccgi_properties_of_type_primary_equipment',
      ccgi_properties_secondary: 'get_all_ccgi_properties_of_type_secondary_equipment',
      ccgi_properties_shoulders: 'get_all_ccgi_properties_of_type_shoulders_equipment',
      ccgi_properties_special_ability: 'get_all_ccgi_properties_of_type_special_ability',
      ccgi_properties_movement_skill: 'get_all_ccgi_properties_of_type_movement_skill',
      ccgi_properties_dungeon_shardstone: 'get_all_ccgi_properties_of_type_dungeon_shardstone',
      ccgi_properties_dungeon_skin: 'get_all_ccgi_properties_of_type_dungeon_skin',
      ccgi_properties_unit: 'get_all_ccgi_properties_of_type_unit',
      special_effect_properties: 'get_all_general_special_effect_properties',
      season_info: 'get_season_info',
      seasonal_ranking_settings: 'get_seasonal_ranking_settings',
      seasonal_challenge_types: 'get_seasonal_challenge_types',
      conversion_tables: 'get_conversion_tables',
      daily_goal_types: 'get_daily_goal_types',
      hints: 'get_hints',
      crafting_settings: 'get_crafting_settings',
      avatars_progress_passives_settings: 'get_avatars_progress_and_passives_settings',
      scene_info_create_dungeon: 'scene_info_create_new_dungeon',
      scene_info_edit_dungeon_properties: 'scene_info_edit_dungeon_properties',
      create_dungeon: 'create_new_dungeon',
      dungeon_for_editing: 'get_dungeon_for_editing',
      dungeon_content_under_construction: 'set_under_construction_dungeon_content',
      dungeon_for_testing: 'get_dungeon_for_testing',
      dungeon_ready_to_publish: 'dungeon_ready_to_publish',
      obtained_stars_rewards_shown: 'obtained_stars_rewards_shown'
    }.freeze

    attr_reader :client

    attr_accessor :sid

    def initialize(
      id,
      password,
      host: Client::HOST,
      port: Client::PORT,
      ssl: Client::SSL,
      path: Client::PATH,
      platform: Client::PLATFORM,
      version: Client::VERSION
    )
      @id = id
      @password = password

      @client = Client.new(
        host: host,
        port: port,
        ssl: ssl,
        path: path,
        platform: platform,
        version: version
      )
    end

    ##
    # Returns application settings
    def app_settings
      @client.request(COMMANDS[__method__])
    end

    ##
    # Authenticates by id and password
    def login(language, id = @id, password = @password)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'password' => password,
          'language' => language
        }
      )
    end

    ##
    # Tries logging in using a login service
    def login_service(service, payload)
      @client.request(
        COMMANDS[__method__],
        {
          'service' => service,
          'service_payload' => payload
        }
      )
    end

    ##
    # Links login service
    def link_login_service(service, payload, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'service' => service,
          'service_payload' => payload
        },
        id,
        @sid
      )
    end

    ##
    # Adds push notifications token
    def add_push_notifications_token(platform, token, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'notif_platform' => platform,
          'token' => token
        },
        id,
        @sid
      )
    end

    ##
    # Returns a player id by name
    def player_id_from_name(name)
      @client.request(
        COMMANDS[__method__],
        { 'name' => name }
      )
    end

    ##
    # Returns player info
    def full_player_info(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Checks the session
    def check_session(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns twitch info
    def twitch_info(id = @id)
      @client.request(
        COMMANDS[__method__],
        {},
        id,
        @sid
      )
    end

    ##
    # Sets player tutorial phase
    def tutorial_phase(tutorial, coins, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'tut_phase' => tutorial,
          'coins_collected' => coins,
          'id_player' => id
        },
        id,
        @sid
      )
    end

    ##
    # Returns suitable dungeons for player
    def suitable_dungeons(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns dungeons from followed list
    def dungeons_from_follow(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns newest dungeons
    def newest_dungeons(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns featured dungeons
    def featured_dungeons(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns suitable dungeon chains for player
    def suitable_dungeon_chains(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns newest dungeon chains
    def newest_dungeon_chains(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns featured dungeon chains
    def featured_dungeon_chains(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Starts the dungeon
    def start_dungeon(owner_id, dungeon_id, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_owner' => owner_id,
          'id_dungeon' => dungeon_id
        },
        id,
        @sid
      )
    end

    ##
    # Starts a random dungeon
    def start_random_dungeon(prev_owner_id, prev_dungeon_id, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_previous_dungeon_owner' => prev_owner_id,
          'id_previous_dungeon' => prev_dungeon_id
        },
        id,
        @sid
      )
    end

    ##
    # Starts the dungeon chain
    def start_dungeon_chain(owner_id, dungeon_chain_id, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_chain_owner' => owner_id,
          'id_dungeon_chain' => dungeon_chain_id
        },
        id,
        @sid
      )
    end

    ##
    # Starts the next dungeon in currently played dungeon chain
    def start_next_dungeon_currently_played_dungeon_chain(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Finishes the dungeon
    def finish_dungeon(owner_id, dungeon_id, details, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_owner' => owner_id,
          'id_dungeon' => dungeon_id,
          'playthrough_details' => details
        },
        id,
        @sid
      )
    end

    ##
    # Finishes the dungeon from dungeon chain
    def finish_dungeon_from_dungeon_chain(
      owner_id,
      dungeon_id,
      dungeon_chain_id,
      details,
      id = @id
    )
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_owner' => owner_id,
          'id_dungeon' => dungeon_id,
          'id_dungeon_chain' => dungeon_chain_id,
          'playthrough_details' => details
        },
        id,
        @sid
      )
    end

    ##
    # Rates the dungeon
    def rate_dungeon(owner_id, dungeon_id, rating, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_owner' => owner_id,
          'id_dungeon' => dungeon_id,
          'chosen_rating' => rating
        },
        id,
        @sid
      )
    end

    ##
    # Rates the dungeon chain
    def rate_dungeon_chain(owner_id, dungeon_chain_id, rating, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_chain_owner' => owner_id,
          'id_dungeon_chain' => dungeon_chain_id,
          'chosen_rating' => rating
        },
        id,
        @sid
      )
    end

    ##
    # Returns dungeon chains marked as "play later"
    def dungeon_chains_play_later(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Removes the dungeon chain from the "play later" list
    def remove_dungeon_chain_play_later(dungeon_chain_id, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_chain' => dungeon_chain_id
        },
        id,
        @sid
      )
    end

    ##
    # Returns currently played dungeon chain
    def currently_played_dungeon_chain(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns dungeon comments
    def dungeon_comments(owner_id, dungeon_id, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_owner' => owner_id,
          'id_dungeon' => dungeon_id
        },
        id,
        @sid
      )
    end

    ##
    # Returns dungeon chain comments
    def dungeon_chain_comments(owner_id, dungeon_chain_id, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_chain_owner' => owner_id,
          'id_dungeon_chain' => dungeon_chain_id
        },
        id,
        @sid
      )
    end

    ##
    # Adds a comment to the dungeon
    def add_dungeon_comment(
      owner_id,
      dungeon_id,
      dungeon_version,
      used_avatar,
      comment,
      id = @id
    )
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_owner' => owner_id,
          'id_dungeon' => dungeon_id,
          'dungeon_version' => dungeon_version,
          'used_avatar' => used_avatar,
          'comment_text' => comment
        },
        id,
        @sid
      )
    end

    ##
    # Adds a comment to the dungeon chain
    def add_dungeon_chain_comment(
      owner_id,
      dungeon_chain_id,
      used_avatar,
      comment,
      id = @id
    )
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon_chain_owner' => owner_id,
          'id_dungeon_chain' => dungeon_chain_id,
          'used_avatar' => used_avatar,
          'comment_text' => comment
        },
        id,
        @sid
      )
    end

    ##
    # Sets player name
    def player_name(name, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'name' => name
        },
        id,
        @sid
      )
    end

    ##
    # Discards a daily goal
    def discard_daily_goal(goal_type, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'daily_goal_type' => goal_type
        },
        id,
        @sid
      )
    end

    ##
    # Returns top players by glory
    def top_players_by_glory(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns top players by stars
    def top_players_by_stars(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns players profile info
    def player_profile_info(player, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_profile' => player
        },
        id,
        @sid
      )
    end

    ##
    # Returns players profile info by name
    def player_profile_info_by_name(name, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'profile_name' => name
        },
        id,
        @sid
      )
    end

    ##
    # Saves the avatars loadout
    def save_avatar_loadout(avatar, loadout, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_avatar' => avatar,
          'loadout' => loadout
        },
        id,
        @sid
      )
    end

    ##
    # Saves the avatars passives
    def save_avatar_passives(avatar, types, levels, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_avatar' => avatar,
          'passives_type_ids' => types,
          'passives_levels' => levels
        },
        id,
        @sid
      )
    end

    ##
    # Claims starter cards reward
    def claim_starter_cards_reward(card, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'selected_card' => card
        },
        id,
        @sid
      )
    end

    ##
    # Claims seasonal rank rewards
    def claim_seasonal_rank_rewards(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Purchases cards pack with coins
    def purchase_cards_pack_with_coins(pack, coins_before, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'pack_type' => pack,
          'coins_before_purchasing' => coins_before
        },
        id,
        @sid
      )
    end

    ##
    # Purchases a card with dust
    def purchase_card_with_dust(card, count, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'card_identifier' => card,
          'new_card_count' => count
        },
        id,
        @sid
      )
    end

    ##
    # Unpacks cards pack
    def unpack_cards_pack(pack, count_before, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'pack_type' => pack,
          'count_available_before_unpacking' => count_before
        },
        id,
        @sid
      )
    end

    ##
    # Subscribes using email
    def subscribe_email(email, language, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'email' => email,
          'language' => language
        },
        id,
        @sid
      )
    end

    ##
    # Sells all equipment duplicates for dust
    def sell_all_duplicates(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Marks new cards as viewed
    def mark_new_cards_viewed(cards, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'card_identifiers' => cards
        },
        id,
        @sid
      )
    end

    ##
    # Returns a new cross platform code
    def cross_platform_new_code(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns a list of players dungeons
    def player_dungeons(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns a following list
    def player_followig_list(player, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player_asking' => id,
          'id_player' => player
        },
        id,
        @sid
      )
    end

    ##
    # Returns a followers list
    def player_followers_list(player, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player_asking' => id,
          'id_player' => player
        },
        id,
        @sid
      )
    end

    ##
    # Adds a player to the following list
    def follow_player(player, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_player_to_follow' => player
        },
        id,
        @sid
      )
    end

    ##
    # Removes a player from the following list
    def unfollow_player(player, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_player_to_unfollow' => player
        },
        id,
        @sid
      )
    end

    ##
    # Creates a new player
    def create_player
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns language localizations
    def localizations(language)
      @client.request(
        COMMANDS[__method__],
        { 'language' => language }
      )
    end

    ##
    # Returns card properties of body equipment
    def ccgi_properties_body
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of hands equipment
    def ccgi_properties_hands
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of head equipment
    def ccgi_properties_head
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of legs equipment
    def ccgi_properties_legs
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of neck equipment
    def ccgi_properties_neck
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of primary equipment
    def ccgi_properties_primary
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of secondary equipment
    def ccgi_properties_secondary
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of shoulders equipment
    def ccgi_properties_shoulders
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of special ability
    def ccgi_properties_special_ability
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of movement skill
    def ccgi_properties_movement_skill
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of dungeon shardstone
    def ccgi_properties_dungeon_shardstone
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of dungeon skin
    def ccgi_properties_dungeon_skin
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns card properties of unit
    def ccgi_properties_unit
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns special effect properties
    def special_effect_properties
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns the current season info
    def season_info
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns seasonal ranking settings
    def seasonal_ranking_settings
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns seasonal challenge types
    def seasonal_challenge_types
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns conversion tables
    def conversion_tables
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns daily goal types
    def daily_goal_types
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns hints
    def hints
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns crafting settings
    def crafting_settings
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns avatars progress and passives settings
    def avatars_progress_passives_settings
      @client.request(COMMANDS[__method__])
    end

    ##
    # Returns available skins and shardstones to create a new dungeon
    def scene_info_create_dungeon(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns dungeon properties for edit
    def scene_info_edit_dungeon_properties(dungeon, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon' => dungeon
        },
        id,
        @sid
      )
    end

    ##
    # Creates a new dungeon
    def create_dungeon(name, skin, shardstone, language, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'name' => name,
          'skin' => skin,
          'shardstone' => shardstone,
          'language' => language
        },
        id,
        @sid
      )
    end

    ##
    # Returns a dungeon for editing
    def dungeon_for_editing(dungeon, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon' => dungeon
        },
        id,
        @sid
      )
    end

    ##
    # Sets under construction dungeon content
    def dungeon_content_under_construction(dungeon, content, placement_price, difficulty, language, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon' => dungeon,
          'serialized_dungeon' => content,
          'placement_price_sum' => placement_price,
          'difficulty' => difficulty,
          'language' => language
        },
        id,
        @sid
      )
    end

    ##
    # Returns a dungeon for testing
    def dungeon_for_testing(dungeon, prefer_published, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon' => dungeon,
          'prefer_published' => prefer_published
        },
        id,
        @sid
      )
    end

    ##
    # Publishes dungeon
    def dungeon_ready_to_publish(dungeon, publish_now, details, id = @id)
      @client.request(
        COMMANDS[__method__],
        {
          'id_player' => id,
          'id_dungeon' => dungeon,
          'publish_now' => publish_now,
          'playthrough_details' => details
        },
        id,
        @sid
      )
    end

    ##
    # Marks as shown obtained stars rewards
    def obtained_stars_rewards_shown(id = @id)
      @client.request(
        COMMANDS[__method__],
        { 'id_player' => id },
        id,
        @sid
      )
    end
  end
end
