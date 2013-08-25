#!/usr/bin/ruby
require 'bigdecimal'

def iqm_v2(filename='data.txt')
  data = []
  File.open(filename,'r') do |f|

    # take linecount of file to determine sampling 5% of set
    # wc seems the quickest
    line_count = `wc -l data.txt`.split.first.to_i * 0.01
    sample_count = 0

    for l in f.each_line do
      data << l.to_i
      if data.length >= 4 && data.length % line_count == 0
        sample_count += 1
        quartile = data.size / 4.0
        ys = data.sort[quartile.ceil-1..(3*quartile).floor]
        factor = quartile - (ys.size/2.0 - 1)

        mean = (ys[1...-1].inject(0, :+) + (ys[0] + ys[-1]) * factor) / (2*quartile)
        total_mean = "#{data.length}: #{"%.2f" % mean}"
        puts total_mean
      end
    end
  puts "sample count is " + sample_count.to_s + ' of ' + data.length.to_s
  return total_mean
  end
end

# memoization
# parallelism
# concurrency
# sampling
# - assuming it aint prime, find factor and div by that


# the larger the data set the less often one has to calculate the IQM from scratch

# 32
# 100
# 102
# 110