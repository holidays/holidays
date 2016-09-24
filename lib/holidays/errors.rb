module Holidays
  class Error < StandardError; end

  class FunctionNotFound < Error; end
  class InvalidFunctionResponse < Error; end
  class UnknownRegionError < Error ; end
  class InvalidRegion < Error; end
end
