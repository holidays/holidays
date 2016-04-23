module Holidays
  class Error < StandardError; end

  class FunctionNotFound < Error; end
  class UnknownRegionError < Error ; end
end
