# frozen_string_literal: true

require 'net/http'
require 'securerandom'

module Monolisk
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

    def initialize(
      host: HOST,
      port: PORT,
      ssl: SSL,
      path: PATH,
      platform: PLATFORM,
      version: VERSION
    )
      @host = host
      @port = port
      @ssl = ssl
      @path = path
      @platform = platform
      @version = version

      @client = Net::HTTP.new(@host, @port)
      @client.use_ssl = @ssl

      @uid = generate_uid
    end

    def request(path, params = {}, pid = PID_DEFAULT, sid = SID_DEFAULT)
      params = params.clone
      params[PARAM_PLATFORM] = @platform
      params[PARAM_APP_VERSION] = @version
      params[PARAM_SESSION_ID] = sid
      params[PARAM_UID] = @uid

      uri_params = params.clone
      uri_params[PARAM_PID] = pid
      uri_params.each_key do |k|
        v = uri_params[k].to_s
        next if v.length <= URI_PARAM_SIZE_LIMIT

        uri_params[k] = v.slice(0, URI_PARAM_SIZE_LIMIT).concat('...')
      end

      params = URI.encode_www_form(params)
      uri_params = URI.encode_www_form(uri_params)

      path = File.join(@path, path)
      query = [path, uri_params].join('&')

      response = @client.post(query, params, HEADERS)
      raise RequestError.new(response.code, response.body, query) unless response.instance_of?(Net::HTTPOK)

      response.body
    end

    private

    def generate_uid
      SecureRandom.alphanumeric(UID_SIZE)
    end
  end

  ##
  # Request error
  class RequestError < StandardError
    attr_reader :code, :data, :uri

    def initialize(code, data, query)
      @code = code
      @data = data
      @query = query

      super(self)
    end

    def to_s
      "#{@data} (#{@code}: #{@query})"
    end
  end
end
