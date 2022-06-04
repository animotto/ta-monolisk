# frozen_string_literal: true

require 'net/http'
require 'securerandom'

module Monolisk
  #
  # Request error
  class RequestError < StandardError
    attr_reader :data, :query, :code

    def initialize(data, query, code = nil)
      @data = data
      @query = query
      @code = code

      super(self)
    end

    def to_s
      return "#{@data} (#{@code}: #{@query})" if @code

      "#{@data} (#{@query})"
    end
  end

  ##
  # Invalid id error
  class InvalidIDError < RequestError; end

  ##
  # Invalid password error
  class InvalidPasswordError < RequestError; end

  ##
  # Invalid session error
  class InvalidSessionError < RequestError; end

  ##
  # Unknown player name error
  class UnknownPlayerNameError < RequestError; end

  ##
  # Dungeon not found error
  class DungeonNotFoundError < RequestError; end

  ##
  # Invalid parameters error
  class InvalidParametersError < RequestError; end

  ##
  # Not enough coins error
  class NotEnoughCoinsError < RequestError; end

  ##
  # Nothing to unpack error
  class NothingToUnpackError < RequestError; end

  ##
  # Client
  class Client
    HOST = 'monolisk.appspot.com'
    PORT = 443
    SSL = true
    PATH = '/pubapi/'
    PLATFORM = 'android'
    VERSION = 1051

    HEADERS = {
      'User-Agent' => 'BestHTTP'
    }.freeze

    PARAM_PID = 'pid'
    PARAM_UID = 'uid'
    PARAM_SESSION_ID = 'session_id'
    PARAM_PLATFORM = 'platform'
    PARAM_APP_VERSION = 'app_version'

    UID_SIZE = 24
    URI_PARAM_SIZE_LIMIT = 150

    PID_DEFAULT = -10
    SID_DEFAULT = 321

    AMOUNT = 5

    ClientStruct = Struct.new(:client, :mutex)

    EXCEPTION_PREFIX = 'com.tricksterarts.monoliskbackend.exceptions.'
    EXCEPTIONS = {
      'InvalidIdException' => InvalidIDError,
      'InvalidPasswordException' => InvalidPasswordError,
      'InvalidSessionException' => InvalidSessionError,
      'UnknownPlayerNameException' => UnknownPlayerNameError,
      'PublishedDungeonNotFoundException' => DungeonNotFoundError,
      'InvalidParametersException' => InvalidParametersError,
      'NotEnoughCoinsException' => NotEnoughCoinsError,
      'NothingToUnpackException' => NothingToUnpackError
    }.freeze

    attr_reader :host, :port, :ssl, :path, :platform, :version, :amount

    def initialize(
      host: HOST,
      port: PORT,
      ssl: SSL,
      path: PATH,
      platform: PLATFORM,
      version: VERSION,
      amount: AMOUNT
    )
      @host = host
      @port = port
      @ssl = ssl
      @path = path
      @platform = platform
      @version = version

      @amount = amount
      @clients = []
      @amount.times do
        client = Net::HTTP.new(@host, @port)
        client.use_ssl = @ssl
        @clients << ClientStruct.new(
          client,
          Mutex.new
        )
      end

      @uid = generate_uid
    end

    def request(path, params = {}, pid = PID_DEFAULT, sid = SID_DEFAULT)
      params = params.clone
      params[PARAM_PLATFORM] = @platform unless params.key?(PARAM_PLATFORM)
      params[PARAM_APP_VERSION] = @version unless params.key?(PARAM_APP_VERSION)
      params[PARAM_SESSION_ID] = sid unless params.key?(PARAM_SESSION_ID)
      params[PARAM_UID] = @uid unless params.key?(PARAM_UID)

      uri_params = params.clone
      uri_params[PARAM_PID] = pid unless uri_params.key?(PARAM_PID)
      uri_params.each_key do |k|
        v = uri_params[k].to_s
        next if v.length <= URI_PARAM_SIZE_LIMIT

        uri_params[k] = v.slice(0, URI_PARAM_SIZE_LIMIT).concat('...')
      end

      params = URI.encode_www_form(params)
      uri_params = URI.encode_www_form(uri_params)

      path = File.join(@path, path)
      query = [path, uri_params].join('&')

      client = @clients.detect { |c| !c.mutex.locked? }
      client = @clients.first if client.nil?
      client.mutex.synchronize do
        begin
          client.client.start unless client.client.started?
          response = client.client.post(query, params, HEADERS)
        rescue StandardError => e
          raise RequestError.new(e.class.to_s, query)
        end

        response.body.force_encoding('UTF-8')

        unless response.instance_of?(Net::HTTPOK)
          if response.body =~ /^#{EXCEPTION_PREFIX}(\w+)/
            exception = Regexp.last_match[1]

            raise EXCEPTIONS.fetch(exception, RequestError).new(response.body, query, response.code)
          end

          raise RequestError.new(response.body, query, response.code)
        end

        return response.body
      end
    end

    private

    def generate_uid
      SecureRandom.alphanumeric(UID_SIZE)
    end
  end
end
