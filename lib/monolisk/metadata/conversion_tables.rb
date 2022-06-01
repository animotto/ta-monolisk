# frozen_string_literal: true

module Monolisk
  module Metadata
    ##
    # Conversion tables
    class ConversionTables < Base
      def load
        @data = @api.conversion_tables
        @data = JSON.parse(@data)
      end

      def exp_to_level(exp)
        level = 0
        @data['levelToExpTable'].each_with_index do |v, i|
          break if v > exp

          level = i
        end

        level
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
