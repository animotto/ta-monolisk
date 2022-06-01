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
    end
  end
end
