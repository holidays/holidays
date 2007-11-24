require File.dirname(__FILE__) + '/test_helper'
require 'date'
require 'holidays'
require 'holidays/ca'
require 'benchmark'



n = 10000
dt = Date.civil(2035,3,23)
Benchmark.bm do |x|

  x.report('0001') do 
    1.times do
        r = Holidays.on(dt, :any)
    end
  end


  x.report('0010') do 
    10.times do
        r = Holidays.on(dt, :any)
    end
  end

  x.report('0100') do 
    100.times do
        r = Holidays.on(dt, :any)
    end
  end

  x.report('1000') do 
    1000.times do
        r = Holidays.on(dt, :any)
    end
  end


  x.report('5000') do 
    5000.times do
        r = Holidays.on(dt, :any)
    end
  end

end