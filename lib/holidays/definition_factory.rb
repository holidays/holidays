require 'holidays/definition/context/generator'
require 'holidays/definition/context/merger'
require 'holidays/definition/decorator/custom_method_source'
require 'holidays/definition/parser/custom_method'
require 'holidays/definition/repository/holidays_by_month'
require 'holidays/definition/repository/regions'
require 'holidays/definition/repository/cache'
require 'holidays/definition/repository/proc_result_cache'
require 'holidays/definition/repository/custom_methods'
require 'holidays/definition/validator/region'

module Holidays
  module DefinitionFactory
    class << self
      def file_parser
        Definition::Context::Generator.new(
          custom_method_parser,
          custom_method_source_decorator,
        )
      end

      def source_generator
        Definition::Context::Generator.new(
          custom_method_parser,
          custom_method_source_decorator,
        )
      end

      def merger
        Definition::Context::Merger.new(
          holidays_by_month_repository,
          regions_repository,
          custom_methods_repository,
        )
      end

      def custom_method_parser
        Definition::Parser::CustomMethod.new
      end

      def custom_method_source_decorator
        Definition::Decorator::CustomMethodSource.new
      end

      def region_validator
        Definition::Validator::Region.new(
          regions_repository
        )
      end

      def holidays_by_month_repository
        @holidays_repo ||= Definition::Repository::HolidaysByMonth.new
      end

      def regions_repository
        @regions_repo ||= Definition::Repository::Regions.new
      end

      def cache_repository
        @cache_repo ||= Definition::Repository::Cache.new
      end

      def proc_result_cache_repository
        @proc_result_cache_repo ||= Definition::Repository::ProcResultCache.new
      end

      def custom_methods_repository
        @custom_methods_repository ||= Definition::Repository::CustomMethods.new
      end
    end
  end
end
