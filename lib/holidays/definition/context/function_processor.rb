require 'holidays/errors'

module Holidays
  module Definition
    module Context
      class FunctionProcessor
        def initialize(custom_methods_repo, proc_result_cache_repo)
          @custom_methods_repo = custom_methods_repo
          @proc_result_cache_repo = proc_result_cache_repo
        end

        def call(year, month, day, func_id, desired_func_args, func_modifier = nil)
          validate!(year, month, day, func_id, desired_func_args)

          function = @custom_methods_repo.find(func_id)
          raise Holidays::FunctionNotFound.new("Unable to find function with id '#{func_id}'") if function.nil?

          calculate(year, month, function, parse_arguments(year, month, day, desired_func_args), func_modifier)
        end

        private

        VALID_ARGUMENTS = [:year, :month, :day, :date]

        def validate!(year, month, day, func_id, desired_func_args)
          raise ArgumentError if desired_func_args.nil? || desired_func_args.empty?

          desired_func_args.each do |name|
            raise ArgumentError unless VALID_ARGUMENTS.include?(name)
          end

          raise ArgumentError if desired_func_args.include?(:year) && !year.is_a?(Integer)
          raise ArgumentError if desired_func_args.include?(:month) && (month < 0 || month > 12)
          raise ArgumentError if desired_func_args.include?(:day) && (day < 1 || day > 31)
        end

        def parse_arguments(year, month, day, target_args)
          args = []

          if target_args.include?(:year)
            args << year
          end

          if target_args.include?(:month)
            args << month
          end

          if target_args.include?(:day)
            args << day
          end

          if target_args.include?(:date)
            args << Date.civil(year, month, day)
          end

          args
        end

        def calculate(year, month, id, args, modifier)
          result = @proc_result_cache_repo.lookup(id, *args)
          if result.kind_of?(Date)
            if modifier
              result = result + modifier # NOTE: This could be a positive OR negative number.
            end
          elsif result.is_a?(Integer)
            begin
              result = Date.civil(year, month, result)
            rescue ArgumentError => e
              raise Holidays::InvalidFunctionResponse.new("invalid day response from custom method call resulting in invalid date. Result: '#{result}'")
            end
          elsif result.nil?
            # Do nothing. This is because some functions can return 'nil' today.
            # I want to change this and so rather than come up with a clean
            # implementation I'll do this so we don't throw an error in this specific
            # situation. This should be removed once we have changed the existing
            # custom definition functions. See https://github.com/holidays/holidays/issues/204
          else
            raise Holidays::InvalidFunctionResponse.new("invalid response from custom method call, must be a 'date' or 'integer' representing the day. Result: '#{result}'")
          end

          result
        end
      end
    end
  end
end
