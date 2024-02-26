# encoding: utf-8
module Holidays
  # This file is generated by the Ruby Holidays gem.
  #
  # Definitions loaded: definitions/sg.yaml
  #
  # All the definitions are available at https://github.com/holidays/holidays
  module SG # :nodoc:
    def self.defined_regions
      [:sg]
    end

    def self.holidays_by_month
      {
              0 => [{:function => "easter(year)", :function_arguments => [:year], :function_modifier => -2, :name => "Good Friday", :regions => [:sg]},
            {:function => "cn_new_lunar_day(year)", :function_arguments => [:year], :observed => "to_monday_if_sunday(date)", :observed_arguments => [:date], :name => "Lunar New Year's Day", :regions => [:sg]},
            {:function => "cn_new_lunar_day(year)", :function_arguments => [:year], :function_modifier => 1, :observed => "to_monday_if_sunday(date)", :observed_arguments => [:date], :name => "The second day of Lunar New Year", :regions => [:sg]},
            {:function => "deepavali(year)", :function_arguments => [:year], :observed => "to_monday_if_sunday(date)", :observed_arguments => [:date], :name => "Deepavali", :regions => [:sg]},
            {:function => "hari_raya_puasa(year)", :function_arguments => [:year], :observed => "to_monday_if_sunday(date)", :observed_arguments => [:date], :name => "Hari Raya Puasa", :regions => [:sg]},
            {:function => "hari_raya_haji(year)", :function_arguments => [:year], :observed => "to_monday_if_sunday(date)", :observed_arguments => [:date], :name => "Hari Raya Haji", :regions => [:sg]},
            {:function => "vesak_day(year)", :function_arguments => [:year], :observed => "to_monday_if_sunday(date)", :observed_arguments => [:date], :name => "Vesak Day", :regions => [:sg]}],
      1 => [{:mday => 1, :observed => "to_weekday_if_weekend(date)", :observed_arguments => [:date], :name => "New Year's Day", :regions => [:sg]}],
      2 => [{:mday => 14, :type => :informal, :name => "Valentine's Day", :regions => [:sg]},
            {:mday => 15, :type => :informal, :name => "Total Defence Day", :regions => [:sg]}],
      5 => [{:mday => 1, :name => "Labour Day", :regions => [:sg]}],
      8 => [{:mday => 9, :observed => "to_weekday_if_weekend(date)", :observed_arguments => [:date], :name => "National Day", :regions => [:sg]}],
      12 => [{:mday => 25, :observed => "to_weekday_if_weekend(date)", :observed_arguments => [:date], :name => "Christmas Day", :regions => [:sg]}]
      }
    end

    def self.custom_methods
      {
        "cn_new_lunar_day(year)" => Proc.new { |year|
month_day = case year
  when 1930, 1949, 1987, 2025, 2063, 2082, 2101, 2112, 2131, 2150, 2207, 2245, 2253, 2283, 2321
    [1, 29]
  when 1931, 1950, 1969, 1988, 2007, 2026, 2045, 2083, 2091, 2102, 2121, 2159, 2197, 2208, 2216, 2227, 2246, 2265, 2303, 2322, 2341, 2379
    [2, 17]
  when 1932, 1951, 1970, 1989, 2027, 2046, 2114, 2179, 2198, 2209, 2247, 2266, 2304, 2323, 2342, 2361, 2399
    [2, 6]
  when 1933, 2009, 2028, 2047, 2066, 2085, 2115, 2161, 2199, 2210, 2229, 2267, 2305, 2316, 2324, 2335, 2381
    [1, 26]
  when 1934, 1953, 2037, 2048, 2067, 2086, 2105, 2116, 2181, 2189, 2211, 2257, 2268, 2306, 2325, 2336
    [2, 14]
  when 1935, 1943, 1992, 2038, 2106, 2144, 2201, 2212, 2258, 2296, 2307, 2326, 2364
    [2, 4]
  when 1936, 1955, 2001, 2039, 2058, 2088, 2107, 2164, 2183, 2221, 2259, 2278, 2308, 2327, 2373
    [1, 24]
  when 1937, 1975, 2032, 2040, 2051, 2070, 2108, 2127, 2146, 2165, 2252, 2260, 2271, 2290, 2309, 2328, 2347, 2366
    [2, 11]
  when 1938, 1957, 1976, 1995, 2014, 2033, 2071, 2109, 2128, 2185, 2272, 2291, 2329, 2348, 2367, 2386
    [1, 31]
  when 1939, 1996, 2015, 2053, 2072, 2110, 2129, 2292, 2330, 2368, 2387
    [2, 19]
  when 1940, 1959, 2016, 2035, 2081, 2130, 2149, 2187, 2206, 2225, 2236, 2255, 2312, 2350, 2358, 2369
    [2, 8]
  when 1941, 1952, 1971, 1990, 2074, 2093, 2123, 2142, 2180, 2248, 2294, 2343, 2351, 2362
    [1, 27]
  when 1942, 1961, 1972, 1991, 2056, 2075, 2094, 2124, 2143, 2200, 2276, 2295, 2344, 2363
    [2, 15]
  when 1944, 1963, 1982, 2020, 2096, 2134, 2153, 2172, 2191, 2202, 2240, 2286, 2354, 2392
    [1, 25]
  when 1945, 1964, 1983, 2010, 2029, 2162, 2192, 2230, 2249, 2317, 2382
    [2, 13]
  when 1946, 2003, 2022, 2041, 2052, 2098, 2147, 2155, 2166, 2223, 2242, 2261, 2299, 2310, 2375, 2394
    [2, 1]
  when 1947, 2004, 2042, 2050, 2080, 2118, 2137, 2194, 2270, 2289, 2300, 2338, 2376
    [1, 22]
  when 1948, 1994, 2013, 2024, 2043, 2089, 2119, 2138, 2157, 2176, 2195, 2214, 2320, 2396
    [2, 10]
  when 1954, 1973, 2011, 2057, 2068, 2087, 2125, 2163, 2231, 2277, 2288, 2345, 2383
    [2, 3]
  when 1956, 2002, 2021, 2059, 2078, 2097, 2135, 2154, 2173, 2184, 2203, 2222, 2241, 2279, 2287, 2298, 2355, 2374, 2393
    [2, 12]
  when 1958, 1977, 2034, 2140, 2178, 2235, 2254, 2273, 2311, 2349, 2360, 2398
    [2, 18]
  when 1960, 1979, 1998, 2006, 2017, 2036, 2055, 2104, 2169, 2188, 2218, 2226, 2237, 2256, 2275, 2313, 2332, 2370, 2389
    [1, 28]
  when 1962, 1981, 2000, 2019, 2065, 2076, 2084, 2095, 2133, 2152, 2171, 2190, 2220, 2239, 2285, 2315, 2334, 2353, 2372, 2391
    [2, 5]
  when 1965, 1984, 2030, 2049, 2060, 2079, 2117, 2136, 2174, 2182, 2193, 2204, 2250, 2269, 2280, 2318, 2337, 2356
    [2, 2]
  when 1966, 2023, 2061, 2099, 2186, 2262, 2281, 2357, 2395
    [1, 21]
  when 1967, 1986, 2005, 2062, 2100, 2168, 2233, 2244, 2263, 2282, 2301, 2339, 2377, 2385, 2388
    [2, 9]
  when 1968, 2044, 2090, 2120, 2139, 2158, 2177, 2196, 2215, 2234, 2264, 2302, 2340, 2359, 2378, 2397
    [1, 30]
  when 1974, 1993, 2012, 2031, 2069, 2077, 2126, 2145, 2156, 2175, 2213, 2232, 2251, 2297, 2346, 2365, 2384
    [1, 23]
  when 1978, 1997, 2008, 2054, 2073, 2092, 2103, 2111, 2122, 2141, 2160, 2217, 2228, 2274, 2293, 2331, 2380
    [2, 7]
  when 1980, 1999, 2018, 2064, 2113, 2132, 2151, 2170, 2219, 2238, 2284, 2314, 2333, 2352, 2371, 2390
    [2, 16]
  when 1985, 2148, 2167, 2205, 2224, 2243
    [2, 20]
  when 2319
    [2, 21]
  end
Date.civil(year, month_day[0], month_day[1])
},

"deepavali(year)" => Proc.new { |year|
month_day = case year
  when 2023
    [11, 12]
  when 2024
    [10, 31]
  when 2025
    [10, 20]
  when 2026
    [10, 08]
  end
Date.civil(year, month_day[0], month_day[1])
},

"hari_raya_haji(year)" => Proc.new { |year|
month_day = case year
  when 2023
    [06, 29]
  when 2024
    [06, 17]
  when 2025
    [06, 06]
  when 2026
    [05, 27]
  end
Date.civil(year, month_day[0], month_day[1])
},

"hari_raya_puasa(year)" => Proc.new { |year|
month_day = case year
  when 2023
    [04, 22]
  when 2024
    [04, 10]
  when 2025
    [03, 31]
  when 2026
    [03, 20]
  end
Date.civil(year, month_day[0], month_day[1])
},

"vesak_day(year)" => Proc.new { |year|
month_day = case year
  when 2023
    [06, 02]
  when 2024
    [05, 22]
  when 2025
    [05, 12]
  when 2026
    [05, 31]
  end
Date.civil(year, month_day[0], month_day[1])
},


      }
    end
  end
end
