require 'holidays/definition/entity/custom_method'

module Holidays
  module Definition
    module Parser
      class CustomMethod
        VALID_ARGUMENTS = ["date", "year", "month", "day"]

        def call(methods)
          return {} if methods.nil? || methods.empty?

          validate!(methods)

          custom_methods = {}

          methods.each do |name, pieces|
            arguments = parse_arguments!(pieces["arguments"])

            custom_methods[method_key(name, arguments)] = Entity::CustomMethod.new({
              name: name,
              arguments: arguments,
              source: pieces["source"],
            })
          end

          custom_methods
        end

        private

        def method_key(name, args)
          "#{name.to_s}(#{args_string(args)})"
        end

        def args_string(args)
          a = args.join(", ")
          a[0..-1]
        end

        #FIXME This should probably be split out into a separate 'custom method' validator and simply called here.
        def validate!(methods)
          methods.each do |name, pieces|
            validate_name!(name)
            validate_arguments!(pieces["arguments"])
            validate_source!(pieces["source"])
          end
        end

        def validate_name!(name)
          raise ArgumentError.new("name cannot be missing") if name.nil? || name.empty?
        end

        def validate_arguments!(arguments)
          splitArgs = arguments.split(",")

          splitArgs.each do |arg|
            if arg != arg.chomp
              raise ArgumentError.new("argument '#{arg}' cannot contain a carriage return")
            end

            if !VALID_ARGUMENTS.include?(arg.strip)
              raise ArgumentError.new("argument '#{arg.strip}' is unrecognized, only the following arguments are allowed at this time: '#{VALID_ARGUMENTS.join(', ')}'")
            end
          end
        end

        def validate_source!(source)
          raise ArgumentError.new("source must not be missing") if source.nil? || source.empty?
        end

        def parse_arguments!(arguments)
          splitArgs = arguments.split(",")
          parsedArgs = []

          splitArgs.each do |arg|
            parsedArgs << arg.strip
          end

          parsedArgs
        end
      end
    end
  end
end
