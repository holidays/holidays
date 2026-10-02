require 'holidays/errors'

module Holidays
  module Definition
    module Repository
      class CustomMethods
        def initialize
          @custom_methods = {}
          @custom_method_sources = {}
        end

        # Registers new custom methods, all or nothing. Re-adding a name that is
        # already registered raises DuplicateCustomMethod, unless both entries
        # carry byte-identical source (reloading the same load_custom file).
        # Methods registered without a source (built-in and bundled) can never
        # be re-added.
        def add(new_custom_methods, new_sources = {})
          raise ArgumentError if new_custom_methods.nil?

          new_keys = new_custom_methods.keys.reject { |key| identical_reload?(key, new_sources[key]) }
          new_keys.each do |key|
            raise Holidays::DuplicateCustomMethod.new("custom method '#{key}' is already registered") if @custom_methods.key?(key)
          end

          new_keys.each do |key|
            @custom_methods[key] = new_custom_methods[key]
            @custom_method_sources[key] = new_sources[key] if new_sources[key]
          end
        end

        def find(method_id)
          raise ArgumentError if method_id.nil? || method_id.empty?

          @custom_methods[method_id]
        end

        private

        def identical_reload?(key, new_source)
          existing_source = @custom_method_sources[key]
          !existing_source.nil? && existing_source == new_source
        end
      end
    end
  end
end
