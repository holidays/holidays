module Holidays
  module Definition
    module Repository
      # ==== Benchmarks
      #
      # Lookup Easter Sunday, with caching, by number of iterations:
      #
      #       user     system      total        real
      # 0001  0.000000   0.000000   0.000000 (  0.000000)
      # 0010  0.000000   0.000000   0.000000 (  0.000000)
      # 0100  0.078000   0.000000   0.078000 (  0.078000)
      # 1000  0.641000   0.000000   0.641000 (  0.641000)
      # 5000  3.172000   0.015000   3.187000 (  3.219000)
      #
      # Lookup Easter Sunday, without caching, by number of iterations:
      #
      #       user     system      total        real
      # 0001  0.000000   0.000000   0.000000 (  0.000000)
      # 0010  0.016000   0.000000   0.016000 (  0.016000)
      # 0100  0.125000   0.000000   0.125000 (  0.125000)
      # 1000  1.234000   0.000000   1.234000 (  1.234000)
      # 5000  6.094000   0.031000   6.125000 (  6.141000)
      class ProcCache
        def initialize
          @proc_cache = {}
        end

        def lookup(function, year)
          proc_key = Digest::MD5.hexdigest("#{function.to_s}_#{year.to_s}")
          @proc_cache[proc_key] = function.call(year) unless @proc_cache[proc_key]
          @proc_cache[proc_key]
        end
      end
    end
  end
end
