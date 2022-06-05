# frozen_string_literal: true

module Monolisk
  module Metadata
    CACHE_DIR = 'cache'
    CACHE_EXT = 'dat'

    ##
    # Builder
    class Builder
      def initialize(game, data_dir)
        @game = game
        @data_dir = data_dir

        @cache_dir = File.join(@data_dir, CACHE_DIR)
        Dir.mkdir(@cache_dir) unless Dir.exist?(@cache_dir)
      end

      def app_settings
        AppSettings.new(@game, @cache_dir)
      end

      def conversion_tables
        ConversionTables.new(@game, @cache_dir)
      end

      def goal_types
        GoalTypes.new(@game, @cache_dir)
      end

      def passives_settings
        PassivesSettings.new(@game, @cache_dir)
      end

      def ccgi_properties
        CCGIProperties.new(@game, @cache_dir)
      end

      def seasonal_challenge_types
        SeasonalChallengeTypes.new(@game, @cache_dir)
      end
    end
  end
end
