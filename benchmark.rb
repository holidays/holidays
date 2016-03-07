require 'benchmark'

puts Benchmark.measure {
  require 'holidays'
  Holidays.between(
    Date.civil(2016, 1, 1), Date.civil(2016, 12, 31), :us
  )
}
