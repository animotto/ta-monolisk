# frozen_string_literal: true

module Monolisk
  module Metadata
    ##
    # Application settings
    class AppSettings < Base
      include Enumerable

      Setting = Struct.new(:key, :value)

      def load
        @data = @api.app_settings
        @data = JSON.parse(@data)

        @app_settings = @data['appSettings'].map { |k, v| Setting.new(k, v) }
      end

      def each(&block)
        @app_settings.each(&block)
      end

      def get(key)
        setting = @app_settings.detect { |s| s.key == key }
        setting.value
      end

      def beta?
        @data['isAppBetaVersion']
      end
    end
  end
end
