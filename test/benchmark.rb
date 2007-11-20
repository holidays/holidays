require File.dirname(__FILE__) + '/test_helper'
require 'date'
require 'benchmark'


n = 10000
Benchmark.bm do |x|
  x.report('calculate_mday') do 
    n.times do

      Holidays.calculate_mday(2008, 1, 1, 3)
    end
  end
  x.report('calculate_mdaya') do 
    n.times do
      Holidays.calculate_mdaya(:third, 1, 1, 2008)
    end
  end
end