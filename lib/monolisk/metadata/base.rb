# frozen_string_literal: true

module Monolisk
  module Metadata
    ##
    # Base
    class Base
      attr_reader :data

      def initialize(api)
        @api = api
      end

      def loaded?
        !@data.nil?
      end

      def load; end
    end
  end
end
