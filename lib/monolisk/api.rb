# frozen_string_literal: true

module Monolisk
  ##
  # API
  class API
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
    # Returns true if there is session id
    def connected?
      !@sid.nil?
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
    # Removes the dungeon chain from "play later"
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
  end
end
