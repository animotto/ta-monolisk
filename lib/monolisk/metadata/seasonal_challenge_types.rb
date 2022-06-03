# frozen_string_literal: true

module Monolisk
  module Metadata
    ##
    # Seasonal challenge types
    class SeasonalChallengeTypes < Base
      include Enumerable

      ChallengeType = Struct.new(:type, :name, :target, :reward, :multiplier)

      def load
        @data = @api.seasonal_challenge_types
        @data = JSON.parse(@data)

        @challenge_types = @data['allSeasonalChallengeDetails'].map do |c|
          ChallengeType.new(
            c['typeId'],
            c['typeName'],
            c['targetValue'],
            c['gloryReward'],
            c['gloryMultiplier']
          )
        end
      end

      def each(&block)
        @challenge_types.each(&block)
      end

      def get(type)
        @challenge_types.detect { |c| c.type == type }
      end
    end
  end
end
