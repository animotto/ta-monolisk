# frozen_string_literal: true

require 'json'

module Monolisk
  ##
  # Game
  class Game
    LANGAUGE = 'EN'

    attr_reader :id, :password, :api, :app_settings, :goal_types,
                :conversion_tables, :passives_settings, :ccgi_properties

    def initialize(
      id = nil,
      password = nil,
      host: Client::HOST,
      port: Client::PORT,
      ssl: Client::SSL,
      path: Client::PATH,
      platform: Client::PLATFORM,
      version: Client::VERSION,
      language: LANGAUGE
    )
      @id = id
      @password = password
      @language = language

      @api = API.new(
        @id,
        @password,
        host: host,
        port: port,
        ssl: ssl,
        path: path,
        platform: platform,
        version: version
      )

      @app_settings = Metadata::AppSettings.new(@api)
      @conversion_tables = Metadata::ConversionTables.new(@api)
      @goal_types = Metadata::GoalTypes.new(@api)
      @passives_settings = Metadata::PassivesSettings.new(@api)
      @ccgi_properties = Metadata::CCGIProperties.new(@api)
    end

    ##
    # Returns true if there is session id
    def connected?
      !@api.sid.nil?
    end

    ##
    # Gets metadata, authenticates by id/password and saves the session id
    def connect
      @app_settings.load
      yield('Application settings') if block_given?

      @conversion_tables.load
      yield('Conversion tables') if block_given?

      @goal_types.load
      yield('Daily goal types') if block_given?

      @passives_settings.load
      yield('Passives settings') if block_given?

      @ccgi_properties.body.load
      yield('CCGI body equipment properties') if block_given?

      @ccgi_properties.hands.load
      yield('CCGI hands equipment properties') if block_given?

      @ccgi_properties.head.load
      yield('CCGI head equipment properties') if block_given?

      @ccgi_properties.legs.load
      yield('CCGI legs equipment properties') if block_given?

      @ccgi_properties.neck.load
      yield('CCGI neck equipment properties') if block_given?

      @ccgi_properties.primary.load
      yield('CCGI primary equipment properties') if block_given?

      @ccgi_properties.secondary.load
      yield('CCGI secondary equipment properties') if block_given?

      @ccgi_properties.shoulders.load
      yield('CCGI shoulders equipment properties') if block_given?

      @ccgi_properties.special_ability.load
      yield('CCGI special ability properties') if block_given?

      @ccgi_properties.movement_skill.load
      yield('CCGI movement skill properties') if block_given?

      @ccgi_properties.dungeon_shardstone.load
      yield('CCGI dungeon shardstone properties') if block_given?

      @ccgi_properties.dungeon_skin.load
      yield('CCGI dungeon skin properties') if block_given?

      @ccgi_properties.unit.load
      yield('CCGI unit properties') if block_given?

      data = @api.login(@language, @id, @password)
      data = JSON.parse(data)
      @api.sid = data['sessionId']
      yield('Login') if block_given?
    end

    ##
    # Erases the session id
    def disconnect
      @api.sid = nil
    end

    ##
    # Checks the session
    def check_session
      @api.check_session
    end
  end
end
