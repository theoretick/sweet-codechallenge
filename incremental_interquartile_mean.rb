#!/usr/bin/ruby
data = []
File.open('data.txt','r') do |f|
  f.each_line do |l|
    data << l.to_i
    if data.length >= 4
      quartile = data.size / 4.0
      ys = data.sort[quartile.ceil-1..(3*quartile).floor]
      factor = quartile - (ys.size/2.0 - 1)

      mean = (ys[1...-1].inject(0, :+) + (ys[0] + ys[-1]) * factor) / (2*quartile)
      puts "#{data.length}: #{"%.2f" % mean}"
    end
  end
end

# COLD RUN
# 100000: 458.82

# real  10m30.413s
# user  10m24.092s
# sys 0m5.517s
