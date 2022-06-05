# frozen_string_literal: true

module Monolisk
  module Metadata
    ##
    # Passives settings
    class PassivesSettings < Base
      include Enumerable

      CACHE_FILE = 'passives_settings'

      PassiveSetting = Struct.new(
        :type,
        :name,
        :avatars,
        :max_level,
        :bonus_value,
        :price
      )

      def load
        unless load_from_cache(@game.app_settings.get('avatarsProgressAndPassivesSettingsVersion'))
          @data = @api.avatars_progress_passives_settings
          @data = JSON.parse(@data)

          save_to_cache(@game.app_settings.get('avatarsProgressAndPassivesSettingsVersion'))
        end

        @passives_settings = @data['allAvatarsPassivesDetails'].map do |passive|
          PassiveSetting.new(
            passive['typeId'],
            passive['typeName'],
            passive['avatars'],
            passive['maxLevel'],
            passive['bonusValue'],
            passive['price']
          )
        end
      end

      def each(&block)
        @passives_settings.each(&block)
      end

      def get(type)
        @passives_settings.detect { |p| p.type == type }
      end

      def glory_for_next_skill_point(skill_points)
        @data['gloryNeededForNextSkillPoint'][skill_points]
      end
    end
  end
end
