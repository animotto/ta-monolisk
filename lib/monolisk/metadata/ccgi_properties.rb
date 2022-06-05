# frozen_string_literal: true

module Monolisk
  module Metadata
    ##
    # CCGI properties
    class CCGIProperties < Base
      attr_reader :body, :hands, :head, :legs, :neck,
                  :primary, :secondary, :shoulders,
                  :special_ability, :movement_skill,
                  :dungeon_shardstone, :dungeon_skin, :unit

      def initialize(*)
        super

        @body = CCGIPropertiesBody.new(@game, @cache_dir)
        @hands = CCGIPropertiesHands.new(@game, @cache_dir)
        @head = CCGIPropertiesHead.new(@game, @cache_dir)
        @legs = CCGIPropertiesLegs.new(@game, @cache_dir)
        @neck = CCGIPropertiesNeck.new(@game, @cache_dir)
        @primary = CCGIPropertiesPrimary.new(@game, @cache_dir)
        @secondary = CCGIPropertiesSecondary.new(@game, @cache_dir)
        @shoulders = CCGIPropertiesShoulders.new(@game, @cache_dir)
        @special_ability = CCGIPropertiesSpecialAbility.new(@game, @cache_dir)
        @movement_skill = CCGIPropertiesMovementSkill.new(@game, @cache_dir)
        @dungeon_shardstone = CCGIPropertiesDungeonShardstone.new(@game, @cache_dir)
        @dungeon_skin = CCGIPropertiesDungeonSkin.new(@game, @cache_dir)
        @unit = CCGIPropertiesUnit.new(@game, @cache_dir)
      end

      def search(id)
        card = nil
        [
          @body, @hands, @head, @legs, @neck,
          @primary, @secondary, @shoulders,
          @special_ability, @movement_skill,
          @dungeon_shardstone, @dungeon_skin, @unit
        ].each do |ccgi|
          card = ccgi.get(id)
          break if card
        end

        card
      end
    end

    ##
    # CCGI base properties
    class CCGIPropertiesBase < Base
      def get(id)
        card_id = id.delete_suffix('+')
        @data.detect { |c| c['identifier'] == card_id }
      end
    end

    ##
    # CCGI body equipment properties
    class CCGIPropertiesBody < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_body'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_bodyEquipment'))

        @data = @api.ccgi_properties_body
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_bodyEquipment'))
      end
    end

    ##
    # CCGI hands equipment properties
    class CCGIPropertiesHands < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_hands'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_handsEquipment'))

        @data = @api.ccgi_properties_hands
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_handsEquipment'))
      end
    end

    ##
    # CCGI head equipment properties
    class CCGIPropertiesHead < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_head'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_headEquipment'))

        @data = @api.ccgi_properties_head
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_headEquipment'))
      end
    end

    ##
    # CCGI legs equipment properties
    class CCGIPropertiesLegs < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_legs'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_legsEquipment'))

        @data = @api.ccgi_properties_legs
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_legsEquipment'))
      end
    end

    ##
    # CCGI neck equipment properties
    class CCGIPropertiesNeck < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_neck'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_neckEquipment'))

        @data = @api.ccgi_properties_neck
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_neckEquipment'))
      end
    end

    ##
    # CCGI primary equipment properties
    class CCGIPropertiesPrimary < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_primary'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_primeryEquipment'))

        @data = @api.ccgi_properties_primary
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_primeryEquipment'))
      end
    end

    ##
    # CCGI secondary equipment properties
    class CCGIPropertiesSecondary < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_secondary'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_secondaryEquipment'))

        @data = @api.ccgi_properties_secondary
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_secondaryEquipment'))
      end
    end

    ##
    # CCGI shoulders equipment properties
    class CCGIPropertiesShoulders < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_shoulders'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_shouldersEquipment'))

        @data = @api.ccgi_properties_shoulders
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_shouldersEquipment'))
      end
    end

    ##
    # CCGI special ability properties
    class CCGIPropertiesSpecialAbility < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_special_ability'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_specialAbility'))

        @data = @api.ccgi_properties_special_ability
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_specialAbility'))
      end
    end

    ##
    # CCGI movement skill properties
    class CCGIPropertiesMovementSkill < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_movement_skill'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_movementSkill'))

        @data = @api.ccgi_properties_movement_skill
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_movementSkill'))
      end
    end

    ##
    # CCGI dungeon shardstone properties
    class CCGIPropertiesDungeonShardstone < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_dungeon_shardstone'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_dungeonShardstone'))

        @data = @api.ccgi_properties_dungeon_shardstone
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_dungeonShardstone'))
      end
    end

    ##
    # CCGI dungeon skin properties
    class CCGIPropertiesDungeonSkin < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_dungeon_skin'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_dungeonSkin'))

        @data = @api.ccgi_properties_dungeon_skin
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_dungeonSkin'))
      end
    end

    ##
    # CCGI unit properties
    class CCGIPropertiesUnit < CCGIPropertiesBase
      CACHE_FILE = 'ccgi_properties_unit'

      def load
        return if load_from_cache(@game.app_settings.get('ccgiPropertiesVersion_unit'))

        @data = @api.ccgi_properties_unit
        @data = JSON.parse(@data)

        save_to_cache(@game.app_settings.get('ccgiPropertiesVersion_unit'))
      end
    end
  end
end
