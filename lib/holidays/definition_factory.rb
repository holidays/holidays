require 'holidays/definition/context/generator'
require 'holidays/definition/context/merger'
require 'holidays/definition/repository/holidays_by_month'
require 'holidays/definition/repository/regions'

module Holidays
  module DefinitionFactory
    class << self
      def file_parser
        Definition::Context::Generator.new
      end

      def source_generator
        Definition::Context::Generator.new
      end

      def merger
        Definition::Context::Merger.new(
          holidays_by_month_repository,
          regions_repository
        )
      end

      def holidays_by_month_repository
        @holidays_repo ||= Definition::Repository::HolidaysByMonth.new
      end

      def regions_repository
        @regions_repo ||= Definition::Repository::Regions.new
      end
    end
  end
end
