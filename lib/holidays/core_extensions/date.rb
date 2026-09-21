module Holidays
  module CoreExtensions
    module Date
      def self.included(base)
        base.extend ClassMethods
        base.include EndOfMonth unless base.method_defined?(:end_of_month)
      end

      # Get holidays on the current date.
      #
      # Returns an array of hashes or nil. See Holidays#between for options
      # and the output format.
      #
      #   Date.civil('2008-01-01').holidays(:ca_)
      #   => [{:name => 'New Year\'s Day',...}]
      #
      # Also available via Holidays#on.
      def holidays(*options)
        Holidays.on(self, *options)
      end

      # Check if the current date is a holiday.
      #
      # Returns true or false.
      #
      #   Date.civil('2008-01-01').holiday?(:ca)
      #   => true
      def holiday?(*options)
        holidays = self.holidays(*options)
        holidays && !holidays.empty?
      end

      # Returns a new Date where one or more of the elements have been changed according to the +options+ parameter.
      # The +options+ parameter is a hash with a combination of these keys: <tt>:year</tt>, <tt>:month</tt>, <tt>:day</tt>.
      #
      #   Date.new(2007, 5, 12).change(day: 1)               # => Date.new(2007, 5, 1)
      #   Date.new(2007, 5, 12).change(year: 2005, month: 1) # => Date.new(2005, 1, 12)
      def change(options)
        ::Date.new(
          options.fetch(:year, year),
          options.fetch(:month, month),
          options.fetch(:day, day)
        )
      end

      # Defined only when the including class has no end_of_month of its own,
      # so implementations such as ActiveSupport's are never shadowed.
      module EndOfMonth
        # Returns the last day of the month as a Date.
        #
        #   Date.new(2016, 8, 1).end_of_month
        #   => #<Date: 2016-08-31 ...>
        def end_of_month
          ::Date.new(year, month, -1)
        end
      end

      module ClassMethods
        def calculate_mday(year, month, week, wday)
          Holidays::Factory::DateCalculator.day_of_month_calculator.call(year, month, week, wday)
        end
      end
    end
  end
end
