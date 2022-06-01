# frozen_string_literal: true

require 'json'

module Monolisk
  ##
  # Game
  class Game
    LANGAUGE = 'EN'

    attr_reader :id, :password, :api, :app_settings, :goal_types,
                :conversion_tables, :passives_settings

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
