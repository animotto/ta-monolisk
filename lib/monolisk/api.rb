# frozen_string_literal: true

module Monolisk
  ##
  # API
  class API
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
      @client.request('get_app_settings')
    end

    ##
    # Authenticates by id and password
    def login(language, id = @id, password = @password)
      @client.request(
        'log_in',
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
        'attempt_logging_in_using_login_service',
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
        'link_login_service',
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
        'add_push_notifications_token',
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
        'get_player_id_from_name',
        { 'name' => name }
      )
    end

    ##
    # Returns player info
    def full_player_info(id = @id)
      @client.request(
        'get_full_player_info',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Checks the session
    def check_session(id = @id)
      @client.request(
        'check_session',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns twitch info
    def twitch_info(id = @id)
      @client.request(
        'get_twitch_info',
        {},
        id,
        @sid
      )
    end

    ##
    # Sets player tutorial phase
    def tutorial_phase(tutorial, coins, id = @id)
      @client.request(
        'set_player_tutorial_phase',
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
        'get_suitable_dungeons_for_player',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns dungeons from followed list
    def dungeons_from_follow(id = @id)
      @client.request(
        'get_dungeons_from_people_i_follow',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns newest dungeons
    def newest_dungeons(id = @id)
      @client.request(
        'get_newest_dungeons',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns featured dungeons
    def featured_dungeons(id = @id)
      @client.request(
        'get_featured_dungeons',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns suitable dungeon chains for player
    def suitable_dungeon_chains(id = @id)
      @client.request(
        'get_suitable_dungeon_chains_for_player',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns newest dungeon chains
    def newest_dungeon_chains(id = @id)
      @client.request(
        'get_newest_dungeon_chains',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns featured dungeon chains
    def featured_dungeon_chains(id = @id)
      @client.request(
        'get_featured_dungeon_chains',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Starts the dungeon
    def start_dungeon(owner_id, dungeon_id, id = @id)
      @client.request(
        'start_dungeon',
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
        'start_random_dungeon',
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
        'start_dungeon_chain',
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
        'start_next_dungeon_in_currently_played_dungeon_chain',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Finishes the dungeon
    def finish_dungeon(owner_id, dungeon_id, details, id = @id)
      @client.request(
        'dungeon_finished',
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
        'dungeon_from_dungeon_chain_finished',
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
        'rate_dungeon',
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
        'rate_dungeon_chain',
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
        'get_play_later_dungeon_chains',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Removes the dungeon chain from the "play later" list
    def remove_dungeon_chain_play_later(dungeon_chain_id, id = @id)
      @client.request(
        'remove_dungeon_chain_from_play_later',
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
        'get_currently_played_dungeon_chain',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns dungeon comments
    def dungeon_comments(owner_id, dungeon_id, id = @id)
      @client.request(
        'get_dungeon_comments',
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
        'get_dungeon_chain_comments',
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
        'add_dungeon_comment',
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
        'add_dungeon_chain_comment',
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
        'set_player_name',
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
        'discard_daily_goal',
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
        'get_top_players_by_glory',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns top players by stars
    def top_players_by_stars(id = @id)
      @client.request(
        'get_top_players_by_stars',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns players profile info
    def player_profile_info(player, id = @id)
      @client.request(
        'get_player_profile_info',
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
        'get_player_profile_info_by_name',
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
        'save_avatar_loadout',
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
        'save_avatar_passives',
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
        'claim_starter_cards_reward',
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
        'claim_seasonal_rank_rewards',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Purchases cards pack with coins
    def purchase_cards_pack_with_coins(pack, coins_before, id = @id)
      @client.request(
        'purchase_cards_pack_with_coins',
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
        'purchase_card_with_dust',
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
        'unpack_cards_pack',
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
        'subscribe_using_email',
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
        'sell_all_equipment_duplicates_for_dust',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Marks new cards as viewed
    def mark_new_cards_viewed(cards, id = @id)
      @client.request(
        'mark_new_cards_as_viewed',
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
        'get_new_cross_platform_connect_code',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns a list of players dungeons
    def player_dungeons(id = @id)
      @client.request(
        'list_players_own_dungeons',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns a following list
    def player_followig_list(player, id = @id)
      @client.request(
        'get_players_following_list',
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
        'get_players_followers_list',
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
        'follow_player',
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
        'unfollow_player',
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
      @client.request('create_player')
    end

    ##
    # Returns language localizations
    def localizations(language)
      @client.request(
        'get_localizations',
        { 'language' => language }
      )
    end

    ##
    # Returns card properties of body equipment
    def ccgi_properties_body
      @client.request('get_all_ccgi_properties_of_type_body_equipment')
    end

    ##
    # Returns card properties of hands equipment
    def ccgi_properties_hands
      @client.request('get_all_ccgi_properties_of_type_hands_equipment')
    end

    ##
    # Returns card properties of head equipment
    def ccgi_properties_head
      @client.request('get_all_ccgi_properties_of_type_head_equipment')
    end

    ##
    # Returns card properties of legs equipment
    def ccgi_properties_legs
      @client.request('get_all_ccgi_properties_of_type_legs_equipment')
    end

    ##
    # Returns card properties of neck equipment
    def ccgi_properties_neck
      @client.request('get_all_ccgi_properties_of_type_neck_equipment')
    end

    ##
    # Returns card properties of primary equipment
    def ccgi_properties_primary
      @client.request('get_all_ccgi_properties_of_type_primary_equipment')
    end

    ##
    # Returns card properties of secondary equipment
    def ccgi_properties_secondary
      @client.request('get_all_ccgi_properties_of_type_secondary_equipment')
    end

    ##
    # Returns card properties of shoulders equipment
    def ccgi_properties_shoulders
      @client.request('get_all_ccgi_properties_of_type_shoulders_equipment')
    end

    ##
    # Returns card properties of special ability
    def ccgi_properties_special_ability
      @client.request('get_all_ccgi_properties_of_type_special_ability')
    end

    ##
    # Returns card properties of movement skill
    def ccgi_properties_movement_skill
      @client.request('get_all_ccgi_properties_of_type_movement_skill')
    end

    ##
    # Returns card properties of dungeon shardstone
    def ccgi_properties_dungeon_shardstone
      @client.request('get_all_ccgi_properties_of_type_dungeon_shardstone')
    end

    ##
    # Returns card properties of dungeon skin
    def ccgi_properties_dungeon_skin
      @client.request('get_all_ccgi_properties_of_type_dungeon_skin')
    end

    ##
    # Returns card properties of unit
    def ccgi_properties_unit
      @client.request('get_all_ccgi_properties_of_type_unit')
    end

    ##
    # Returns special effect properties
    def special_effect_properties
      @client.request('get_all_general_special_effect_properties')
    end

    ##
    # Returns the current season info
    def season_info
      @client.request('get_season_info')
    end

    ##
    # Returns seasonal ranking settings
    def seasonal_ranking_settings
      @client.request('get_seasonal_ranking_settings')
    end

    ##
    # Returns seasonal challenge types
    def seasonal_challenge_types
      @client.request('get_seasonal_challenge_types')
    end

    ##
    # Returns conversion tables
    def conversion_tables
      @client.request('get_conversion_tables')
    end

    ##
    # Returns daily goal types
    def daily_goal_types
      @client.request('get_daily_goal_types')
    end

    ##
    # Returns hints
    def hints
      @client.request('get_hints')
    end

    ##
    # Returns crafting settings
    def crafting_settings
      @client.request('get_crafting_settings')
    end

    ##
    # Returns avatars progress and passives settings
    def avatars_progress_passives_settings
      @client.request('get_avatars_progress_and_passives_settings')
    end

    ##
    # Returns available skins and shardstones to create a new dungeon
    def scene_info_create_dungeon(id = @id)
      @client.request(
        'scene_info_create_new_dungeon',
        { 'id_player' => id },
        id,
        @sid
      )
    end

    ##
    # Returns dungeon properties for edit
    def scene_info_edit_dungeon_properties(dungeon, id = @id)
      @client.request(
        'scene_info_edit_dungeon_properties',
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
        'create_new_dungeon',
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
        'get_dungeon_for_editing',
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
        'set_under_construction_dungeon_content',
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
        'get_dungeon_for_testing',
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
        'dungeon_ready_to_publish',
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
  end
end
