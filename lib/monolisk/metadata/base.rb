# frozen_string_literal: true

module Monolisk
  module Metadata
    ##
    # Base
    class Base
      attr_reader :data

      def initialize(game, cache_dir)
        @game = game
        @api = game.api
        @cache_dir = cache_dir
      end

      def loaded?
        !@data.nil?
      end

      def load; end

      private

      def load_from_cache(version)
        cache_file = cache_filename(version)
        return unless File.file?(cache_file)

        @data = JSON.parse(File.read(cache_file))
      end

      def save_to_cache(version)
        File.write(cache_filename(version), JSON.generate(@data))
      end

      def cache_filename(version)
        File.join(@cache_dir, "#{self.class::CACHE_FILE}_#{version}.#{CACHE_EXT}")
      end
    end
  end
end
