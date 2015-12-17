require 'holidays/definition/entity/custom_method'

module Holidays
  module Definition
    module Parser
      class CustomMethod
        def call(methods)
          return {} if methods.nil? || methods.empty?

          validate!(methods)

          custom_methods = {}

          #FIXME Why check this here? Why don't we just validate it? Dumb. and we check for nil/empty above! Just do it in the validator, jesus.
          if methods
            methods.each do |name, pieces|
              custom_methods[name.to_sym] = Entity::CustomMethod.new({
                name: name,
                arguments: parse_arguments!(pieces["arguments"]),
                source: pieces["source"],
              })
            end
          end

          custom_methods
        end

        private

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
              raise ArgumentError.new("argument of #{arg} cannot contain a carriage return")
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
