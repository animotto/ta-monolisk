# frozen_string_literal: true

module Monolisk
  module Metadata
    ##
    # Conversion tables
    class ConversionTables < Base
      CACHE_FILE = 'conversion_tables'

      def load
        return if load_from_cache(@game.app_settings.get('conversionTablesVersion'))

        @data = @api.conversion_tables
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('conversionTablesVersion'))
      end

      def exp_to_level(exp)
        level = 0
        @data['levelToExpTable'].each_with_index do |v, i|
          break if v > exp

          level = i
        end

        level
      end

      def level_to_exp(level)
        level = @data['levelToExpTable'].length - 1 if level >= @data['levelToExpTable'].length
        @data['levelToExpTable'][level]
      end

      def stars_for_next_reward(stars)
        next_reward = 0
        @data['obtainedStarsRewardTiers'].each do |reward|
          next_reward = reward
          break if reward > stars
        end

        next_reward
      end
    end
  end
end
