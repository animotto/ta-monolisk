# frozen_string_literal: true

module Monolisk
  module Metadata
    ##
    # Goal types
    class GoalTypes < Base
      include Enumerable

      GoalType = Struct.new(:type, :name, :target, :reward)

      def load
        @data = @api.daily_goal_types
        @data = JSON.parse(@data)

        @goal_types = @data['allDailyGoalDetails'].map do |goal_type|
          GoalType.new(
            goal_type['type'],
            goal_type['typeName'],
            goal_type['targetValue'],
            goal_type['coinsReward']
          )
        end
      end

      def each(&block)
        @goal_types.each(&block)
      end

      def get(type)
        @goal_types.detect { |g| g.type == type }
      end
    end
  end
end
