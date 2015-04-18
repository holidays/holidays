require 'holidays/definitions/generator'

module Holidays
  module Definitions
    class << self
      def file_parser
        Generator.new
      end

      def source_generator
        Generator.new
      end
    end
  end
end
