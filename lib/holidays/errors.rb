module Holidays
  class Error < StandardError; end

  class FunctionNotFound < Error; end
  class InvalidFunctionResponse < Error; end

  class UnknownRegionError < Error ; end
  class InvalidRegion < Error; end

  class DefinitionTestError < Error; end

  # Raised when a calculation needs data for a year outside the range its
  # tables or formula support, e.g. a lunar date past the end of the lunar
  # calendar tables.
  class UnsupportedYearError < Error; end
end
