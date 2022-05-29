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
    end

    ##
    # Returns true if there is session id
    def connected?
      !@api.sid.nil?
    end

    ##
    # Gets metadata, authenticates by id/password and saves the session id
    def connect
      @app_settings = @api.app_settings
      @app_settings = JSON.parse(@app_settings)
      yield('Application settings') if block_given?

      @conversion_tables = @api.conversion_tables
      @conversion_tables = JSON.parse(@conversion_tables)
      yield('Conversion tables') if block_given?

      @goal_types = @api.daily_goal_types
      @goal_types = JSON.parse(@goal_types)
      yield('Daily goal types') if block_given?

      @passives_settings = @api.avatars_progress_passives_settings
      @passives_settings = JSON.parse(@passives_settings)
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
