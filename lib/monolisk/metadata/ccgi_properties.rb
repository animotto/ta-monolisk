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

        @body = CCGIPropertiesBody.new(@api)
        @hands = CCGIPropertiesHands.new(@api)
        @head = CCGIPropertiesHead.new(@api)
        @legs = CCGIPropertiesLegs.new(@api)
        @neck = CCGIPropertiesNeck.new(@api)
        @primary = CCGIPropertiesPrimary.new(@api)
        @secondary = CCGIPropertiesSecondary.new(@api)
        @shoulders = CCGIPropertiesShoulders.new(@api)
        @special_ability = CCGIPropertiesSpecialAbility.new(@api)
        @movement_skill = CCGIPropertiesMovementSkill.new(@api)
        @dungeon_shardstone = CCGIPropertiesDungeonShardstone.new(@api)
        @dungeon_skin = CCGIPropertiesDungeonSkin.new(@api)
        @unit = CCGIPropertiesUnit.new(@api)
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
      def load
        @data = @api.ccgi_properties_body
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI hands equipment properties
    class CCGIPropertiesHands < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_hands
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI head equipment properties
    class CCGIPropertiesHead < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_head
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI legs equipment properties
    class CCGIPropertiesLegs < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_legs
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI neck equipment properties
    class CCGIPropertiesNeck < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_neck
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI primary equipment properties
    class CCGIPropertiesPrimary < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_primary
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI secondary equipment properties
    class CCGIPropertiesSecondary < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_secondary
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI shoulders equipment properties
    class CCGIPropertiesShoulders < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_shoulders
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI special ability properties
    class CCGIPropertiesSpecialAbility < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_special_ability
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI movement skill properties
    class CCGIPropertiesMovementSkill < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_movement_skill
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI dungeon shardstone properties
    class CCGIPropertiesDungeonShardstone < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_dungeon_shardstone
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI dungeon skin properties
    class CCGIPropertiesDungeonSkin < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_dungeon_skin
        @data = JSON.parse(@data)
      end
    end

    ##
    # CCGI unit properties
    class CCGIPropertiesUnit < CCGIPropertiesBase
      def load
        @data = @api.ccgi_properties_unit
        @data = JSON.parse(@data)
      end
    end
  end
end
