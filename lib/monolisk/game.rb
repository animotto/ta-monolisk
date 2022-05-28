# frozen_string_literal: true

require 'json'

module Monolisk
  ##
  # Game
  class Game
    LANGAUGE = 'EN'

    attr_reader :id, :password, :api, :app_settings, :goal_types

    def initialize(
      id,
      password,
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
    # Authenticates by id/password and saves the session id
    def connect
      @app_settings = @api.app_settings
      @app_settings = JSON.parse(@app_settings)
      yield('Application settings') if block_given?

      @goal_types = @api.daily_goal_types
      @goal_types = JSON.parse(@goal_types)
      yield('Daily goal types') if block_given?

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
